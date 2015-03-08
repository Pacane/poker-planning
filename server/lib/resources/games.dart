library games_resource;

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:redstone/server.dart' as app;
import 'package:shelf/shelf.dart' as shelf;

final GAMES = "/games";
final PATH_ID = "/:id/";
final GAME = GAMES + PATH_ID;

@app.Group('/games')
class Games {
  GameRepository gameRepository;

  Games(this.gameRepository);

  @app.DefaultRoute()
  List<Game> getGames() => gameRepository.games.values.toList();

  @app.DefaultRoute(methods: const [app.PUT], responseType: 'application/json')
  Map addGame(@app.Body(app.JSON) Map json) {
    Game newGame = new Game.fromMap(json)..id = Game.getNewId;

    gameRepository.games.putIfAbsent(newGame.id, () => newGame);

    return newGame.toJson();
  }

  @app.Route('/:id', responseType: 'application/json')
  getGame(int id) {
    Game game = gameRepository.games[id];
    if (gameRepository.games[id] == null) {
      return new shelf.Response.notFound("");
    } else {
      return game;
    }
  }
}
