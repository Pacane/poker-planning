library players_resource;

import 'package:poker_planning_shared/player.dart';
import 'package:poker_planning_server/repository/player_repository.dart';

import 'package:redstone/server.dart' as app;
import 'package:shelf/shelf.dart' as shelf;

import 'dart:convert' show JSON;

const PLAYERS = "/players";
const PATH_ID = "/:id";

@app.Group("/players")
class Players {
  PlayerRepository playerRepository;

  Players(this.playerRepository);

  @app.DefaultRoute(methods: const [app.POST], responseType: 'application/json')
  shelf.Response addPlayer(@app.Body(app.JSON) Map json) {
    String displayName = json['displayName'];

    if (displayName == null || displayName.isEmpty) {
      return new shelf.Response.notFound("");
    }

    Player createdPlayer = playerRepository.createPlayer(displayName);

    return new shelf.Response.ok(JSON.encode(createdPlayer));
  }
}
