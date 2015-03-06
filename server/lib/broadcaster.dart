import 'dart:convert';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_shared/game.dart';

import 'package:logging/logging.dart';

class Broadcaster {
  Logger logger = Logger.root;
  GameRepository _gameRepository;

  Broadcaster(this._gameRepository);

  void broadcastGame(Game game, bool reveal) {
    var encodedGame = {
    };

    if (reveal) {
      encodedGame = {
          'gameId': game.id,
          "revealedGame" : game.players
      };
    } else {
      Map newGame = new Map.from(game.players);
      newGame.forEach((player, card) {
        if (card != "") {
          newGame[player] = "Y";
        }
      });

      encodedGame = {
          'gameId': game.id,
          "game" : newGame
      };
    }

    logger.info("PRINTING GAME : $encodedGame");
    broadcastData(game, JSON.encode(encodedGame));
  }

  void broadcastData(Game game, data) {
    logger.info("Broadcasting to game #${game.id} : $data");
    var encodedData = JSON.encode(data);
    _gameRepository.activeConnections[game].forEach((s) => s.add(encodedData));
  }
}
