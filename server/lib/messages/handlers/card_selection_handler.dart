library card_selection_handler;

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/messages/card_selection_event.dart';
import 'package:poker_planning_shared/messages/game_information.dart';

class CardSelectionHandler extends MessageHandler<CardSelectionEvent> {
  Broadcaster broadcaster;
  GameRepository gameRepository;
  Logger logger = Logger.root;

  CardSelectionHandler(this.gameRepository, this.broadcaster) : super();

  Future handleMessage(CardSelectionEvent message) async {
    int playerId = message.playerId;
    var selectedCard = message.selectedCard;
    int gameId = message.gameId;

    logger.info("Adding $playerId card selection: $selectedCard in game $gameId");

    if (!gameRepository.gameExists(gameId)) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    Game game = gameRepository.games[gameId];

    game.setCard(playerId, selectedCard);

    broadcaster.broadcastData(game, new GameInformation(gameId, game));
  }
}
