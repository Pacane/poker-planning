library game_broadcaster;

import 'dart:convert';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_shared/game.dart';

import 'package:logging/logging.dart';

class Broadcaster {
  Logger logger = Logger.root;
  GameRepository _gameRepository;

  Broadcaster(this._gameRepository);

  void broadcastData(Game game, data) {
    logger.info("Broadcasting to game #${game.id} : $data");
    var encodedData = JSON.encode(data);
    _gameRepository.activeConnections[game].forEach((s) => s.add(encodedData));
  }
}
