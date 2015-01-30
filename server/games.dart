import 'package:start/start.dart';
import 'dart:convert' show JSON;
import 'dart:async';
import 'package:poker_planning_shared/game.dart';

final GAMES = "/games";
final PATH_ID = "/:id/";
final GAME = GAMES + PATH_ID;

class Games {
  Future<Server> startGamesServer() {
    List<Game> games = [];

    return start(port: 3010).then((Server app) {
      print("Starting http server");
      app.get(GAMES).listen((request) {
        request.response
        .header("Access-Control-Allow-Origin", "*")
        .json(games);
      });

      app.options(GAMES).listen((Request request) {
        print("options");
        request.response.header("Access-Control-Allow-Origin", "http://localhost:8080");
        request.response.header("Access-Control-Allow-Methods", "PUT, POST, GET, OPTIONS");
        request.response.status(200);
        request.response.send("");
      });

      app.put(GAMES).listen((Request request) {
        request.response.header("Access-Control-Allow-Origin", "http://localhost:8080");

        request.input.listen((data) {
          String json = new String.fromCharCodes(data);
          Game newGame = new Game.fromJson(json)..id = Game.getNewId;
          games.add(newGame);
          request.response.json(newGame.toJson());
          print('received: $json');
        });
      });

      app.get(GAME).listen((request) {
        int gameId = int.parse(request.param('id'), onError: (source) => -1);

        if (games.length - 1 < gameId || gameId == -1) {
          request.response.status(404).send("");
        } else {
          request.response
          .send(JSON.encode(games[gameId]));
        }
      });

      app.post(GAME + 'bob').listen((request) {
        int gameId = int.parse(request.param('id'));
        Game game = games[gameId];

        game.name = 'allo';

        request.response
        .send(JSON.encode(game));
      });
    });
  }
}
