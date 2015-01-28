library game;

import 'dart:convert' show JSON;

class Game {
  Map<String, String> game = {};
  String test;

  Game(this.game, this.test);

  Map toJson() {
    Map map = new Map();
    map["game"] = game;
    map["test"] = test;
    return map;
  }

  factory Game.fromMap(Map jsonMap) {
    return new Game(jsonMap["game"], jsonMap["test"]);
  }

  factory Game.fromJson(String json) {
    Map data = JSON.decode(json);
    return new Game(data["game"], data["test"]);
  }
}
