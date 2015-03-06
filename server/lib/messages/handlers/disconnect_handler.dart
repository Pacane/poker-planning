library disconnect_handler;

import 'dart:io';
import 'dart:async';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handler.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';
import 'package:poker_planning_shared/messages/game_information.dart';

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

    broadcaster.broadcastData(game, new GameInformation(gameId, false, game));

    new Future.delayed(new Duration(seconds:1), () {
      if (game.players.isEmpty) {
        // TODO : Maybe plug this to the Websocket so the list is refreshed live on clients
        gameRepository.games.remove(game.id);
      }
    });
  }
}
