library game;

import 'dart:convert' show JSON;

class Game {
  int id;

  String name;
  Map<String, String> _players = {};
  bool revealed = false;

  Game(this.name, this._players);

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
    map["players"] = _players;
    map["id"] = id;
    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    print(jsonMap["players"]);
    return new Game(jsonMap["name"], jsonMap["players"])
      ..id = jsonMap["id"]
      .._players = jsonMap["players"] == null ? {} : jsonMap["players"];
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game.fromMap(data);
  }

  static int _idSeed = 1;
  static int get getNewId => _idSeed++;
}
