library game;

import 'dart:convert' show JSON;
import 'package:quiver/strings.dart';

class Game {
  int id;

  String name;
  Map<String, String> _players = {};
  DateTime lastReset;
  bool revealed = false;
  bool isProtected = false;

  Game(this.name, this.revealed, this._players);

  void addPlayer(String playerId) {
    _players.putIfAbsent(playerId, () => '');
  }

  void resetCards() {
    _players.forEach((player, _) => _players[player] = "");
  }

  bool hasPlayers() {
    return _players.isEmpty;
  }

  void removePlayer(String playerId) {
    _players.remove(playerId);
  }

  void setCard(String player, String card) {
    _players[player] = card;
  }

  void obfuscateSelectedCards() {
    _players.forEach((player, card) {
      if (card != "") {
        _players[player] = "Y";
      }
    });
  }

  bool playerIsInGame(String playerId) {
    return _players.containsKey(playerId);
  }

  void forEachPlayer(action) {
    _players.forEach((String player, String card) => action(player, card));
  }

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["revealed"] = revealed;
    map["players"] = _players;
    map["id"] = id;
    map["lastReset"] = lastReset == null ? "" : lastReset.toIso8601String();
    map["isProtected"] = isProtected;

    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    var mapLastReset = jsonMap["lastReset"];

    return new Game(jsonMap["name"], jsonMap["revealed"], jsonMap["players"])
      ..id = jsonMap["id"]
      ..revealed = jsonMap["revealed"] == null ? false : jsonMap["revealed"]
      ..lastReset = isEmpty(mapLastReset) ? null : DateTime.parse(mapLastReset)
      .._players = jsonMap["players"] == null ? {} : jsonMap["players"]
      ..isProtected = jsonMap["isProtected"];
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game.fromMap(data);
  }

  static int _idSeed = 1;
  static int get getNewId => _idSeed++;
}
