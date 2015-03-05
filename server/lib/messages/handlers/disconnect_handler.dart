library disconnect_handler;

import 'dart:io';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handler.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';

class DisconnectHandler extends ConnectionMessageHandler<DisconnectEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  DisconnectHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(DisconnectEvent message, WebSocket socket) {
    int gameId = message.gameId;
    String username = message.username;

    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    gameRepository.activeConnections[game].remove(socket);
    game.players.remove(username);

    broadcaster.broadcastGame(game, false);
  }
}
