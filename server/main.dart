import 'dart:io';
import 'dart:convert';

import 'package:dart_config/default_server.dart';

import 'package:poker_planning_server/interceptors.dart';
import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/messages/handlers/login_handler.dart';
import 'package:poker_planning_server/messages/handlers/disconnect_handler.dart';
import 'package:poker_planning_server/messages/handlers/kick_handler.dart';
import 'package:poker_planning_server/messages/handlers/reveal_request_handler.dart';
import 'package:poker_planning_server/messages/handlers/card_selection_handler.dart';
import 'package:poker_planning_server/messages/handlers/game_reset_handler.dart';
import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/repository/game_repository.dart';

import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/messages/message_factory.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handlers.dart';
import 'package:poker_planning_shared/loglevel_parser.dart';

import 'package:di/di.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:redstone/server.dart' as app;

GameRepository gameRepository;
MessageFactory messageFactory;
MessageHandlers messageHandlers;
ConnectionMessageHandlers connectionMessageHandlers;
Broadcaster broadcaster;

Map<String, String> game = {};
var allConnections = [];
Map<WebSocket, String> loggedInUsers = {};
var hostname;
var port;
var restPort;
Logger logger = Logger.root;

void handleMessage(socket, message) {
  logger.info("Received : " + message);

  Map decodedMessage = JSON.decode(message);

  messageHandlers.handleMessage(decodedMessage);
  connectionMessageHandlers.handleMessage(decodedMessage, socket);
}

void startSocket() {
  logger.info("Starting websocket...!");
  HttpServer.bind(hostname, port).then((server) {
    server.listen((HttpRequest req) {
      if (req.uri.path == '/ws') {
        WebSocketTransformer.upgrade(req)..then((socket) => socket.listen((msg) => handleMessage(socket, msg)));
      }
    })..onError((e) => logger.warning("An error occurred."));
  });
}

void main() {
  loadConfig().then((Map config) {
    hostname = config["hostname"];
    port = config["port"];
    restPort = config["restPort"];
    if (hostname == null) throw ("hostname wasn't set in config.yaml");
    if (port == null) throw ("port wasn't set in config.yaml");
    if (restPort == null) throw ("restPort wasn't set in config.yaml");
    logger.level = LogLevelParser.logLevel(config["logLevel"]);
  }).catchError(showError).then((_) => startGamesServer()).then((_) => startSocket());
}

void showError(error) => logger.severe(error);

startGamesServer() {
  Injector injector = new ModuleInjector([
    new Module()
      ..bind(GameRepository)
      ..bind(MessageFactory)
  ]);

  gameRepository = injector.get(GameRepository);
  messageFactory = injector.get(MessageFactory);
  broadcaster = new Broadcaster(gameRepository);

  messageHandlers = new MessageHandlers(messageFactory, [
    new KickHandler(gameRepository, broadcaster),
    new CardSelectionHandler(gameRepository, broadcaster),
    new RevealRequestHandler(gameRepository, broadcaster),
    new GameResetHandler(gameRepository, broadcaster)
  ]);

  connectionMessageHandlers = new ConnectionMessageHandlers(messageFactory, [
    new LoginHandler(gameRepository, broadcaster),
    new DisconnectHandler(gameRepository, broadcaster)
  ]);

  setupLogging();

  app.addModule(new Module()
    ..bind(Interceptors)
    ..bind(Games)
    ..bind(GameRepository, toValue: gameRepository)
    ..bind(MessageFactory, toValue: messageFactory)
    ..bind(Broadcaster, toValue: broadcaster));

  app.start(port: restPort);
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
    })
    ..listen(new SyncFileLoggingHandler("logging.txt"));
}
