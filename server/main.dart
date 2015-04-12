import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:dart_config/default_server.dart';

import 'package:poker_planning_server/broadcaster.dart';
import 'package:poker_planning_server/messages/handlers/login_handler.dart';
import 'package:poker_planning_server/messages/handlers/disconnect_handler.dart';
import 'package:poker_planning_server/messages/handlers/kick_handler.dart';
import 'package:poker_planning_server/messages/handlers/reveal_request_handler.dart';
import 'package:poker_planning_server/messages/handlers/card_selection_handler.dart';
import 'package:poker_planning_server/messages/handlers/game_reset_handler.dart';
import 'package:poker_planning_server/repository/game_repository.dart';
import 'production_module.dart' as modules;

import 'package:poker_planning_shared/messages/message_factory.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';
import 'package:poker_planning_shared/messages/handlers/connection_message_handlers.dart';
import 'package:poker_planning_shared/loglevel_parser.dart';

import 'package:di/di.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:redstone/server.dart' as app;

Injector injector;
MessageHandlers messageHandlers;
ConnectionMessageHandlers connectionMessageHandlers;

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

Future startSocket() async {
  logger.info("Starting websocket...!");
  try {
    HttpServer server = await HttpServer.bind(hostname, port);
    server.listen((HttpRequest req) async {
      if (req.uri.path == '/ws') {
        WebSocket socket = await WebSocketTransformer.upgrade(req);
        socket.listen((msg) => handleMessage(socket, msg));
      }
    });
  } catch (e) {
    logger.warning("An error occurred.");
  }
}

Future main() async {
  Map config = await loadConfig();
  hostname = config["hostname"];
  port = config["port"];
  restPort = config["restPort"];
  if (hostname == null) throw ("hostname wasn't set in config.yaml");
  if (port == null) throw ("port wasn't set in config.yaml");
  if (restPort == null) throw ("restPort wasn't set in config.yaml");
  logger.level = LogLevelParser.logLevel(config["logLevel"]);

  injector = new ModuleInjector([modules.getProductionModule()]);

  startGamesServer(injector, [modules.getProductionModule(), modules.getRestModule()]);
  startSocket();
}

void showError(error) => logger.severe(error);

void startGamesServer(Injector injector, List<Module> modules) {
  GameRepository gameRepository = injector.get(GameRepository);
  Broadcaster broadcaster = injector.get(Broadcaster);
  MessageFactory messageFactory = injector.get(MessageFactory);

  messageHandlers = new MessageHandlers(messageFactory, [
    new KickHandler(gameRepository, broadcaster),
    new CardSelectionHandler(gameRepository, broadcaster),
    new RevealRequestHandler(gameRepository, broadcaster),
    new ResetGameHandler(gameRepository, broadcaster)
  ]);

  connectionMessageHandlers = new ConnectionMessageHandlers(messageFactory, [
    new LoginHandler(gameRepository, broadcaster),
    new DisconnectHandler(gameRepository, broadcaster)
  ]);

  setupLogging();

  modules.forEach((module) => app.addModule(module));

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
