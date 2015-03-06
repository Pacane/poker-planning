library poker_planning;

import 'dart:html';
import 'dart:async';

import 'package:poker_planning_client/components/home/home.dart';
import 'package:poker_planning_client/components/home/home_login.dart';
import 'package:poker_planning_client/components/lobby/lobby.dart';
import 'package:poker_planning_client/components/lobby/lobby_game.dart';
import 'package:poker_planning_client/components/game/game.dart';
import 'package:poker_planning_client/components/game/game_card.dart';
import 'package:poker_planning_client/components/game/game_player.dart';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/app_router.dart';
import 'package:poker_planning_client/messages/handlers/kick_handler.dart';
import 'package:poker_planning_client/messages/handlers/game_information_handler.dart';
import 'package:poker_planning_client/messages/handlers/game_reset_handler.dart';
import 'package:poker_planning_shared/messages/message_factory.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';
import 'package:poker_planning_client/config.dart' as PPConfig;

import 'package:dart_config/default_browser.dart' as Config;

import 'package:angular_node_bind/angular_node_bind.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';

class PokerPlanningModule extends Module {
  PokerPlanningModule(String hostname, int port) {
    Logger.root..onRecord.listen((LogRecord r) { print(r.message); });

    SocketCommunication socket = new SocketCommunication(hostname, port);
    socket.initWebSocket();

    bind(MessageFactory, toValue: new MessageFactory());
    bind(MessageHandlers,
      toFactory: (MessageFactory messageFactory, kickHandler, resetHandler, gameInformationHandler) {
        new MessageHandlers(messageFactory, [kickHandler, resetHandler, gameInformationHandler]);
      },
      inject: [MessageFactory, KickHandler, GameResetHandler, GameInformationHandler]);
    bind(SocketCommunication, toValue: socket);
    bind(HomeComponent);
    bind(LoginComponent);
    bind(MyCard);
    bind(TableCard);
    bind(GameComponent);
    bind(GamesComponent);
    bind(CreateGameComponent);
    bind(CurrentUser);
    bind(CurrentGame);
    bind(KickHandler);
    bind(GameInformationHandler);
    bind(GameResetHandler);
    bind(RouteInitializerFn, toImplementation: AppRouter);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

main() async {
  PPConfig.Config config = new PPConfig.Config();
  config.config = await Config.loadConfig();
  var hostname = config.config["hostname"];
  var port = config.config["port"];
  var restPort = config.config["restPort"];
  if (hostname == null) throw("hostname wasn't set in config.yaml");
  if (port == null) throw("port wasn't set in config.yaml");
  if (restPort == null) throw("restPort wasn't set in config.yaml");
  config.initConfig();

  applicationFactory()
    .addModule(new PokerPlanningModule(hostname, port)
      ..bind(PPConfig.Config, toValue: config))
    .addModule(new NodeBindModule())
    .run();
}
