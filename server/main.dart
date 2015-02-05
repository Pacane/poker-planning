import 'dart:io';
import 'dart:convert';

import 'package:dart_config/default_server.dart';

import 'package:poker_planning_server/interceptors.dart';
import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/loglevel_parser.dart';

import 'package:di/di.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:redstone/server.dart' as app;

GameRepository gameRepository;

Map<String, String> game = {};
var allConnections = [];
Map<WebSocket, String> loggedInUsers = {
};
var hostname;
var port;
var restPort;
Logger logger = Logger.root;

void resetGame(Game game) {
  logger.info("sending reset signal");
  broadcastData(game, JSON.encode({
      "gameHasReset": game.id
  }));
}

void handleMessage(socket, message) {
  logger.info("Received : " + message);

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

    logger.info("Adding $login to the logged in users of the game # $gameId");
    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players.putIfAbsent(username, () => '');
    gameRepository.addConnection(game, socket);

    broadcastGame(game, false);
  } else if (cardSelection != null) {
    var playerName = cardSelection[0];
    var selectedCard = cardSelection[1];
    int gameId = cardSelection[2];
    logger.info("Adding $playerName card selection: $selectedCard in game $gameId");

    Game game = gameRepository.games[gameId];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    game.players[playerName] = selectedCard;

    broadcastGame(game, false);
  } else if (reveal != null) {
    Game game = gameRepository.games[reveal];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
      return;
    }

    broadcastGame(game, true);
  } else if (reset != null) {
    Game game = gameRepository.games[reset];

    if (game == null) {
      logger.info("Game doesn't exist"); // TODO: Do something
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
      logger.info("Game doesn't exist"); // TODO: Do something
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
      logger.info("Game doesn't exist"); // TODO: Do something
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

  logger.info("PRINTING GAME : $encodedGame");
  broadcastData(game, JSON.encode(encodedGame));
}

void broadcastData(Game game, data) {
  gameRepository.activeConnections[game].forEach((s) => s.add(data));
}

void startSocket() {
  logger.info("Starting websocket...!");
  HttpServer.bind(hostname, port).then((server) {
    server.listen((HttpRequest req) {
      if (req.uri.path == '/ws') {
        WebSocketTransformer.upgrade(req)
          ..then((socket) => socket.listen((msg) => handleMessage(socket, msg)));
      }
    })
      ..onError((e) => logger.warning("An error occurred."));
  });
}

void main() {
  loadConfig()
  .then((Map config) {
    hostname = config["hostname"];
    port = config["port"];
    restPort = config["restPort"];
    if (hostname == null) throw("hostname wasn't set in config.yaml");
    if (port == null) throw("port wasn't set in config.yaml");
    if (restPort == null) throw("restPort wasn't set in config.yaml");
    logger.level = LogLevelParser.logLevel(config["logLevel"]);
  }).catchError(showError)
  .then((_) => startGamesServer())
  .then((_) => startSocket()
  );
}

void showError(error) => logger.severe(error);

startGamesServer() {
  Injector injector = new ModuleInjector([new Module()
    ..bind(GameRepository)
  ]);

  gameRepository = injector.get(GameRepository);

  setupLogging();

  app.addModule(new Module()
    ..bind(Interceptors)
    ..bind(Games)
    ..bind(GameRepository, toValue: gameRepository)
  );

  app.start(port:restPort);
}

void setupLogging() {
  Logger.root.onRecord.asBroadcastStream()
    ..listen((LogRecord rec) {
      if (rec.level >= Level.SEVERE) {
        var stack = rec.stackTrace != null ? "\n${Trace.format(rec.stackTrace)}" : "";
        print('${rec.level.name}: ${rec.time}: ${rec.message} - ${rec.error}${stack}');
      } else {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      }
  })..listen(new SyncFileLoggingHandler("logging.txt"));
}
