library game;

import 'dart:convert' show JSON;

class Game {
  int id;

  String name;
  Map<String, String> players = {};

  Game(this.name, this.players);

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["game"] = players;
    map["id"] = id;
    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    return new Game(jsonMap["name"], jsonMap["game"])
      ..id = jsonMap["id"]
      ..players = jsonMap["game"] == null ? {} : jsonMap["game"]
    ;
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game.fromMap(data);
  }

  static int _idSeed = 1;
  static int get getNewId => _idSeed++;
}
