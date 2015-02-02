library game;

import 'dart:convert' show JSON;

class Game {
  int id;

  String name;
  Map<String, String> game = {};

  Game(this.name, this.game);

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["game"] = game;
    map["id"] = id;
    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    return new Game(jsonMap["name"], jsonMap["game"])
      ..id = jsonMap["id"]
      ..game = jsonMap["game"] == null ? {} : jsonMap["game"]
    ;
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game.fromMap(data);
  }

  static int _idSeed = 1;
  static int get getNewId => _idSeed++;
}
