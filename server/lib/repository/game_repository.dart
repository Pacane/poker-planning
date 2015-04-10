library game_repository;

import 'dart:io';

import 'package:poker_planning_shared/game.dart';

class GameRepository {
  Map<int, String> _passwords = {};
  Map<int, Game> games = {};
  Map<Game, List<WebSocket>> activeConnections = {};

  void setPassword(int gameId, String password) {
    _passwords[gameId] = password;
    games[gameId].isProtected = password != null;
  }

  bool isPasswordValid(int gameId, String password) => _passwords[gameId] == password;

  void addConnection(Game game, WebSocket connection) {
    activeConnections.putIfAbsent(game, () => []);
    activeConnections[game].add(connection);
  }
}
