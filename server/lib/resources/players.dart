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

  @app.Route('/check', methods: const [app.POST])
  shelf.Response checkUserExists(@app.Body(app.JSON) Map json) {
    Player player = new Player.fromMap(json);

    if (playerRepository.playerExists(player)) {
      return new shelf.Response.ok("");
    } else {
      return new shelf.Response.notFound("");
    }
  }

  @app.Route('/:id', responseType: 'application/json')
  shelf.Response getPlayer(int id) {
    Player player = playerRepository.getPlayer(id);

    if (player != null) {
      return new shelf.Response.ok(JSON.encode(player));
    } else {
      return new shelf.Response.notFound("");
    }
  }
}
