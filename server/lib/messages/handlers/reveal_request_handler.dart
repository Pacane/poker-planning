library reveal_handler;

import 'package:logging/logging.dart';
import 'dart:async';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/reveal_request_event.dart';
import 'package:poker_planning_shared/messages/game_information.dart';

class RevealRequestHandler extends MessageHandler<RevealRequestEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  RevealRequestHandler(this.gameRepository, this.broadcaster) : super();

  Future handleMessage(RevealRequestEvent message) async {
    var gameId = message.gameId;

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    game.revealed = true;

    broadcaster.broadcastData(game, new GameInformation(gameId, game));
  }
}
