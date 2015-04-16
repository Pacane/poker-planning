library player_service;

import 'dart:convert' show JSON;
import 'dart:async';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/services/player_api_paths.dart';
import 'package:poker_planning_shared/player.dart';

import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

@Injectable()
class PlayerService {
  PlayerApiPaths paths;
  http.Client client = new BrowserClient();

  PlayerService(this.paths);

  Future<Player> createPlayer(String displayName) async {
    http.Response response = await client.post(paths.players(),
        headers: {'Content-type': 'application/json'}, body: JSON.encode({'displayName': displayName}));

    try {
      return new Player.fromJson(response.body);
    } on FormatException catch (e) {
      throw new Exception("Cannot parse player");
    }
  }

  Future<Player> getPlayer(int kickedBy) async {
    http.Response response = await client.get(paths.getPlayer(kickedBy));

    try {
      return new Player.fromJson(response.body);
    } on FormatException catch (e) {
      throw new Exception("Cannot parse player");
    }
  }
}
