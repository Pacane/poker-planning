library game_reset_handler;

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/reset_game_event.dart';
import 'package:poker_planning_shared/messages/game_has_reset_event.dart';

class ResetGameHandler extends MessageHandler<ResetGameEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  ResetGameHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(ResetGameEvent message) {
    int gameId = message.gameId;

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    game.revealed = false;

    game.resetCards();
    game.lastReset = new DateTime.now().toUtc();

    broadcaster.broadcastData(game, new GameHasResetEvent(game.lastReset));
  }
}
