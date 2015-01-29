library poker_planning;

import 'dart:html';
import 'dart:async';

import 'package:poker_planning_client/components/my_card.dart';
import 'package:poker_planning_client/components/table_card.dart';
import 'package:poker_planning_client/components/login_component.dart';
import 'package:poker_planning_client/components/game_component.dart';
import 'package:poker_planning_client/components/games_component.dart';
import 'package:poker_planning_client/components/create_game_component.dart';
import 'package:poker_planning_client/components/home_component.dart';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/app_router.dart';

import 'package:dart_config/default_browser.dart' as Config;

import 'package:angular_node_bind/angular_node_bind.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';

class PokerPlanningModule extends Module {
  PokerPlanningModule(String hostname, int port) {

    Logger.root..level = Level.FINER
    ..onRecord.listen((LogRecord r) { print(r.message); });

    SocketCommunication socket = new SocketCommunication(hostname, port);
    socket.initWebSocket();

    bind(SocketCommunication, toValue: socket);
    bind(HomeComponent);
    bind(LoginComponent);
    bind(MyCard);
    bind(TableCard);
    bind(GameComponent);
    bind(GamesComponent);
    bind(CreateGameComponent);
    bind(CurrentUser);
    bind(RouteInitializerFn, toImplementation: AppRouter);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

main() async {
  Map config = await Config.loadConfig();
  var hostname = config["hostname"];
  var port = config["port"];
  if (hostname == null) throw("hostname wasn't set in config.yaml");
  if (port == null) throw("port wasn't set in config.yaml");

  applicationFactory()
  .addModule(new PokerPlanningModule(hostname, port))
  .addModule(new NodeBindModule())
  .run();
}
