library player;

import 'dart:convert' show JSON;
import 'package:quiver/core.dart';

class Player {
  int id;
  String displayName;

  Map toJson() {
    Map json = {};
    json["id"] = id;
    json["displayName"] = displayName;

    return json;
  }

  Player();

  factory Player.fromMap(Map json) {
    return new Player()
      ..id = json["id"]
      ..displayName = json["displayName"];
  }

  factory Player.fromJson(String json) {
    return new Player.fromMap(JSON.decode(json));
  }

  toString() => "{ID: $id, DisplayName: $displayName}";

  bool operator ==(Player o) => o is Player && id == o.id && displayName == o.displayName;
  int get hashCode => hash2(id.hashCode, displayName.hashCode);
}
