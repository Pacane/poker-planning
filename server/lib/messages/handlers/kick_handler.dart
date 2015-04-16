library kick_handler;

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/kick_event.dart';

class KickHandler extends MessageHandler<KickEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  KickHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(KickEvent message) {
    int kickedPlayerId = message.kickedPlayerId;
    int gameId = message.gameId;

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    game.removePlayer(kickedPlayerId);
    broadcaster.broadcastData(game, message);
  }
}
