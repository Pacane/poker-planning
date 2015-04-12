library game_repository;

import 'dart:io';

import 'package:poker_planning_shared/game.dart';

class GameRepository {
  Map<int, String> _passwords = {};
  Map<int, Game> games = {};
  Map<Game, List<WebSocket>> activeConnections = {};

  GameRepository() {
    _idSeed = 1;
  }

  void setPassword(int gameId, String password) {
    _passwords[gameId] = password;
    games[gameId].isProtected = password != null;
  }

  bool isPasswordValid(int gameId, String password) => _passwords[gameId] == password;

  void addConnection(Game game, WebSocket connection) {
    activeConnections.putIfAbsent(game, () => []);
    activeConnections[game].add(connection);
  }

  Game createGame(Game newGame, String password) {
    newGame
      ..id = getNewId
      ..lastReset = new DateTime.now().toUtc();

    games.putIfAbsent(newGame.id, () => newGame);
    setPassword(newGame.id, password);

    return newGame;
  }

  int _idSeed;
  int get getNewId => _idSeed++;
}
