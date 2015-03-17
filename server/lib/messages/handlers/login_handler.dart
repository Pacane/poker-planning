library login_handler;

import 'dart:io';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handler.dart';
import 'package:poker_planning_shared/messages/login_event.dart';
import 'package:poker_planning_shared/messages/game_information.dart';

class LoginHandler extends ConnectionMessageHandler<LoginEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  LoginHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(LoginEvent message, WebSocket socket) {
    int gameId = message.gameId;
    String username = message.username;

    logger.info("Adding $username to the logged in users of the game # $gameId");
    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.addPlayer(username);
    gameRepository.addConnection(game, socket);

    broadcaster.broadcastData(game, new GameInformation(gameId, game.revealed, game));
  }
}
