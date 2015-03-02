import 'dart:convert';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/kick_event.dart';


class KickEventHandler extends MessageHandler<KickEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  KickEventHandler(this.gameRepository, this.broadcaster) : super();

  void handleMessage(KickEvent message) {
    String kickedPlayer = message.kicked;
    String kickedBy = message.kickedBy;
    int gameId = message.gameId;

    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.remove(kickedPlayer);
    broadcaster.broadcastData(game, JSON.encode(message.toJson()));
  }
}
