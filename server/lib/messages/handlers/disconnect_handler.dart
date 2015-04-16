library disconnect_handler;

import 'dart:io';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/repository/player_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handler.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';
import 'package:poker_planning_shared/messages/game_information.dart';

class DisconnectHandler extends ConnectionMessageHandler<DisconnectEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  PlayerRepository playerRepository;
  Logger logger = Logger.root;

  DisconnectHandler(this.gameRepository, this.broadcaster, this.playerRepository) : super();

  void handleMessage(DisconnectEvent message, WebSocket socket) {
    int gameId = message.gameId;
    int userId = message.userId;

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    gameRepository.activeConnections[game].remove(socket);
    game.removePlayer(userId);
    playerRepository.removePlayer(userId);

    broadcaster.broadcastData(game, new GameInformation(gameId, game));
  }
}
