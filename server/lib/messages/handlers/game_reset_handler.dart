library game_reset_handler;

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/game_reset_event.dart';

class GameResetHandler extends MessageHandler<GameResetEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  GameResetHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(GameResetEvent message) {
    int gameId = message.gameId;

    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.forEach((player, _) => game.players[player] = "");
    broadcaster.broadcastData(game, new GameResetEvent(gameId));
  }
}
