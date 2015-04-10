library game_service;

import 'dart:convert' show JSON;
import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';

import 'api_paths.dart';

import 'package:poker_planning_shared/game.dart';

import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

@Injectable()
class GameService {
  ApiPaths paths;
  http.Client client = new BrowserClient();

  GameService(this.paths);

  Future<bool> doesGameExist(int gameId) async {
    http.Response response = await client.get(paths.game(gameId));

    if (response.statusCode == 404) {
      return false;
    }

    try {
      new Game.fromJson(response.body);
    } catch (e) {
      return false;
    }

    return true;
  }
}
