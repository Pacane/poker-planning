library game_repository;

import 'dart:io';

import 'package:poker_planning_shared/game.dart';

class GameRepository {
  Map<int, Game> games = {};

  Map<Game, List<WebSocket>> activeConnections = {};

  void addConnection(Game game, WebSocket connection) {
    activeConnections.putIfAbsent(game, () => []);
    activeConnections[game].add(connection);
  }
}