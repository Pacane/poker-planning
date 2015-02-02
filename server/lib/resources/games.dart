library games_resource;

import 'package:poker_planning_shared/game.dart';
import 'package:redstone/server.dart' as app;

final GAMES = "/games";
final PATH_ID = "/:id/";
final GAME = GAMES + PATH_ID;

@app.Group('/games')
class Games {
  List<Game> games = [];

  @app.DefaultRoute()
  List<Game> getGames() => games;

  @app.DefaultRoute(methods: const [app.PUT], responseType: 'application/json')
  Map addGame(@app.Body(app.JSON) Map json) {
    Game newGame = new Game.fromMap(json)
      ..id = Game.getNewId;

    games.add(newGame);

    return newGame.toJson();
  }
}
