library games_resource;

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/player.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:redstone/server.dart' as app;
import 'package:shelf/shelf.dart' as shelf;

import 'dart:convert' show JSON;

final GAMES = "/games";
final PATH_ID = "/:id/";
final GAME = GAMES + PATH_ID;

@app.Group('/games')
class Games {
  GameRepository gameRepository;

  Games(this.gameRepository);

  @app.DefaultRoute()
  List<Game> getGames() => gameRepository.games.values.toList();

  @app.DefaultRoute(methods: const [app.POST], responseType: 'application/json')
  shelf.Response addGame(@app.Body(app.JSON) Map json) {
    Game newGame = new Game.fromMap(json);
    String password = json['password'];

    newGame = gameRepository.createGame(newGame, password);

    return new shelf.Response.ok(JSON.encode(newGame));
  }

  @app.Route('/:id', responseType: 'application/json')
  shelf.Response getGame(int id) {
    if (gameRepository.gameExists(id)) {
      Game game = gameRepository.games[id];
      return new shelf.Response.ok(JSON.encode(game));
    } else {
      return new shelf.Response.notFound("");
    }
  }

  @app.Route('/:id/players', responseType: 'application/json')
  shelf.Response getPlayers(int id) {
    if (gameRepository.gameExists(id)) {
      List<Player> displayNames = gameRepository.getDisplayNames(id).toList();
      if (displayNames.isEmpty) {
        return new shelf.Response.ok(JSON.encode([]));
      } else {
        return new shelf.Response.ok(JSON.encode(displayNames));
      }
    } else {
      return new shelf.Response.notFound("");
    }
  }

  @app.Route('/:id/auth', methods: const [app.POST])
  shelf.Response authenticate(int id, @app.Body(app.JSON) Map body) {
    if (gameRepository.isPasswordValid(id, body['password'])) {
      return new shelf.Response.ok("");
    } else {
      return new shelf.Response.notFound("");
    }
  }
}
