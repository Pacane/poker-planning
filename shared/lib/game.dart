library game;

import 'dart:convert' show JSON;
import 'package:quiver/strings.dart';

class Game {
  int id;

  String name;
  Map<int, String> _players = {};
  DateTime lastReset;
  bool revealed = false;
  bool isProtected = false;

  Game(this.name, this.revealed, this._players);

  void addPlayer(int playerId) {
    _players.putIfAbsent(playerId, () => '');
  }

  void resetCards() {
    _players.forEach((player, _) => _players[player] = "");
  }

  bool hasPlayers() {
    return _players.isEmpty;
  }

  void removePlayer(int playerId) {
    _players.remove(playerId);
  }

  void setCard(int playerId, String card) {
    _players[playerId] = card;
  }

  void obfuscateSelectedCards() {
    _players.forEach((player, card) {
      if (card != "") {
        _players[player] = "Y";
      }
    });
  }

  bool isPlayerInTheGame(int playerId) {
    return _players.containsKey(playerId);
  }

  Iterable<int> getPlayerIds() => _players.keys;

  void forEachPlayer(action) {
    _players.forEach((int playerId, String card) => action(playerId, card));
  }

  Map toJson() {
    Map<String, String> encodablePlayers = {};
    _players.forEach((key, value) => encodablePlayers[key.toString()] = value);

    Map map = new Map();
    map["name"] = name;
    map["revealed"] = revealed;
    map["players"] = encodablePlayers;
    map["id"] = id;
    map["lastReset"] = lastReset == null ? "" : lastReset.toIso8601String();
    map["isProtected"] = isProtected;

    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    var mapLastReset = jsonMap["lastReset"];
    Map<String, String> encodedPlayers = jsonMap["players"];
    Map<int, String> decodedPlayers = {};

    if (encodedPlayers == null) {
      decodedPlayers = {};
    } else {
      encodedPlayers.forEach((String key, String value) => decodedPlayers[int.parse(key)] = value);
    }

    return new Game(jsonMap["name"], jsonMap["revealed"], jsonMap["players"])
      ..id = jsonMap["id"]
      ..revealed = jsonMap["revealed"] == null ? false : jsonMap["revealed"]
      ..lastReset = isEmpty(mapLastReset) ? null : DateTime.parse(mapLastReset)
      .._players = decodedPlayers
      ..isProtected = jsonMap["isProtected"];
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game.fromMap(data);
  }
}
