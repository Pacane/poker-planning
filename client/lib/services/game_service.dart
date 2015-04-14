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

  Future<Game> getGame(int gameId) async {
    http.Response response = await client.get(paths.game(gameId));

    if (response.statusCode == 404) {
      return null;
    }

    try {
      return new Game.fromJson(response.body);
    } on FormatException catch (e) {
      throw new Exception("Cannot parse game");
    }
  }

  Future<bool> gameExists(int gameId) async {
    Game game = await getGame(gameId);

    return game != null;
  }

  Future<bool> isGameProtected(int gameId) async {
    Game game = await getGame(gameId);

    if (game == null) {
      throw new Exception("Game doesn't exist");
    }

    return game.isProtected;
  }

  Future<bool> isPasswordValid(int gameId, String password) async {
    http.Response response = await client.post(paths.authenticate(gameId),
        body: JSON.encode({'password': password}), headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
