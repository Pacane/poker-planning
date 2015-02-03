import 'dart:io';
import 'dart:convert';

import 'package:dart_config/default_server.dart';

import 'package:poker_planning_server/interceptors.dart';
import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';

import 'package:di/di.dart';

import 'package:logging/logging.dart';
import 'package:redstone/server.dart' as app;

GameRepository gameRepository;

Map<String, String> game = {};
var allConnections = [];
Map<WebSocket, String> loggedInUsers = {
};
var hostname;
var port;


void printGame() {
  print("The players connected are : ");
  game.forEach((k, v) => print("$k and their current card choice is: $v"));
}

void resetGame(Game game) {
  print("sending reset signal");
  broadcastData(game, JSON.encode({
      "gameHasReset": game.id
  }));
}

void handleMessage(socket, message) {
  print("Received : " + message);

  Map json = JSON.decode(message);

  var login = json["login"];
  var cardSelection = json["cardSelection"];
  var reveal = json["revealAll"];
  var reset = json["resetRequest"];
  var kicked = json["kicked"];
  var disconnect = json["disconnect"];

  if (login != null) {
    int gameId = login['gameId'];
    String username = login['username'];

    print("Adding $login to the logged in users of the game # $gameId");
    Game game = gameRepository.games[gameId];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.putIfAbsent(username, () => '');
    gameRepository.addConnection(game, socket);

    broadcastGame(game, false);
  } else if (cardSelection != null) {
    var playerName = cardSelection[0];
    var selectedCard = cardSelection[1];
    int gameId = cardSelection[2];
    print("Adding $playerName card selection: $selectedCard in game $gameId");

    Game game = gameRepository.games[gameId];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players[playerName] = selectedCard;

    broadcastGame(game, false);
  } else if (reveal != null) {
    Game game = gameRepository.games[reveal];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    broadcastGame(game, true);
  } else if (reset != null) {
    Game game = gameRepository.games[reset];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.forEach((player, _) => game.players[player] = "");
    resetGame(game);
    broadcastGame(game, false);
  } else if (kicked != null) {
    String kickedPlayer = kicked[0];
    String kickedBy = kicked[1];
    int gameId = kicked[2];

    Game game = gameRepository.games[gameId];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.remove(kickedPlayer);
    broadcastData(game, JSON.encode(
        {
            "kick" :
            {
                "kicked" : kickedPlayer,
                "kickedBy" : kickedBy,
                "gameId" : game.id
            }
        })
    );
  } else if (disconnect != null) {
    String playerName = disconnect[0];
    int gameId = disconnect[1];
    Game game = gameRepository.games[gameId];

    if (game == null) {
      print("Game doesn't exist"); // TODO: Do something
      return;
    }

    gameRepository.activeConnections[game].remove(socket);
    game.players.remove(playerName);

    broadcastGame(game, false);
  }
}

void broadcastGame(Game game, bool reveal) {
  var encodedGame = {
  };

  if (reveal) {
    encodedGame = {
        'gameId': game.id,
        "revealedGame" : game.players
    };
  } else {
    Map newGame = new Map.from(game.players);
    newGame.forEach((player, card) {
      if (card != "") {
        newGame[player] = "Y";
      }
    });

    encodedGame = {
        'gameId': game.id,
        "game" : newGame
    };
  }

  print("PRINTING GAME : $encodedGame");
  broadcastData(game, JSON.encode(encodedGame));
}

void broadcastData(Game game, data) {
  gameRepository.activeConnections[game].forEach((s) => s.add(data));
}

void startSocket() {
  print("Starting websocket...!");
  HttpServer.bind(hostname, port).then((server) {
    server.listen((HttpRequest req) {
      if (req.uri.path == '/ws') {
        WebSocketTransformer.upgrade(req)
          ..then((socket) => socket.listen((msg) => handleMessage(socket, msg)));
      }
    })
      ..onError((e) => print("An error occurred."));
  });
}

void main() {
  loadConfig()
  .then((Map config) {
    hostname = config["hostname"];
    port = config["port"];
  }).catchError((error) => print(error))
  .then((_) {
    if (hostname == null) throw("hostname wasn't set in config.yaml");
  }).catchError(showError)
  .then((_) {
    if (port == null) throw("port wasn't set in config.yaml");
  }).catchError(showError)
  .then((_) => startGamesServer())
  .then((_) => startSocket()
  );
}

void showError(error) => print(error);

startGamesServer() {
  Injector injector = new ModuleInjector([new Module()
    ..bind(GameRepository)
  ]);

  gameRepository = injector.get(GameRepository);

  app.setupConsoleLog(Level.FINE);
  app.addModule(new Module()
    ..bind(Interceptors)
    ..bind(Games)
    ..bind(GameRepository, toValue: gameRepository)
  );

  app.start(port:3010);
}
