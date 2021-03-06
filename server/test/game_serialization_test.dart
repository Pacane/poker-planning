import 'package:test/test.dart';
import 'package:poker_planning_shared/game.dart';

import 'dart:convert' show JSON;

void main() {
  test('Game Serialization, null lastReset', () {
    Game game = new Game("Bob", true, new Map<int, String>());
    String json = JSON.encode(game);
    expect(json, equals('{"name":"Bob","revealed":true,"players":{},"id":null,"lastReset":"","isProtected":false}'));
  });

  test('Game Serialization, non-null lastReset', () {
    Game game = new Game("Bob", true, new Map<int, String>())..lastReset = new DateTime(2014, DateTime.APRIL, 29, 6, 4);
    String json = JSON.encode(game);
    expect(json, equals(
        '{"name":"Bob","revealed":true,"players":{},"id":null,"lastReset":"2014-04-29T06:04:00.000","isProtected":false}'));
  });

  test('Game Copy, non-null lastReset', () {
    Game game = new Game("Bob", true, new Map<int, String>())..lastReset = new DateTime(2014, DateTime.APRIL, 29, 6, 4);

    Game gameCopy = new Game.fromMap(JSON.decode(JSON.encode(game)));
    expect(gameCopy, isNotNull);
  });

  test('Game Copy, null lastReset', () {
    Game game = new Game("Bob", true, new Map<int, String>())..lastReset = null;

    Game gameCopy = new Game.fromMap(JSON.decode(JSON.encode(game)));
    expect(gameCopy, isNotNull);
  });

  test('Game.fromMap, null lastReset', () {
    Map map = new Map();

    Game game = new Game.fromMap(map);
    expect(game, isNotNull);
  });

  test('Game.fromMap, empty lastReset', () {
    Map map = new Map();
    map['lastReset'] = "";

    Game game = new Game.fromMap(map);
    expect(game, isNotNull);
  });
}
