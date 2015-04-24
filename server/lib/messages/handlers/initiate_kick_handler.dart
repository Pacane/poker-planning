library kick_handler;

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/repository/player_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/player.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/initiate_kick_event.dart';
import 'package:poker_planning_shared/messages/player_kicked_event.dart';

class InitiateKickHandler extends MessageHandler<InitiateKickEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  PlayerRepository playerRepository;
  Logger logger = Logger.root;

  InitiateKickHandler(this.gameRepository, this.playerRepository, this.broadcaster) : super();

  Future handleMessage(InitiateKickEvent message) async {
    int kickedPlayerId = message.kickedPlayerId;
    int gameId = message.gameId;

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    Player kickedPlayer = playerRepository.getPlayer(kickedPlayerId);
    Player kickedBy = playerRepository.getPlayer(kickedPlayerId);

    game.removePlayer(kickedPlayerId);

    broadcaster.broadcastData(game, new PlayerKickedEvent(gameId, kickedPlayer, kickedBy));
  }
}
