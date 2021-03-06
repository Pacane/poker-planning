library poker_planning;

import 'dart:async';

import 'package:dart_config/default_browser.dart' as Config;

import 'package:angular_node_bind/angular_node_bind.dart';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';

import 'package:poker_planning_client/components/home/home.dart';
import 'package:poker_planning_client/components/home/home_login.dart';
import 'package:poker_planning_client/components/lobby/lobby.dart';
import 'package:poker_planning_client/components/lobby/lobby_game.dart';
import 'package:poker_planning_client/components/game/game.dart';
import 'package:poker_planning_client/components/game/game_card.dart';
import 'package:poker_planning_client/components/game/game_player.dart';

import 'package:poker_planning_client/services/api_paths.dart';
import 'package:poker_planning_client/services/player_api_paths.dart';
import 'package:poker_planning_client/services/game_api_paths.dart';
import 'package:poker_planning_client/services/time_api_paths.dart';
import 'package:poker_planning_client/services/game_service.dart';
import 'package:poker_planning_client/services/time_service.dart';
import 'package:poker_planning_client/services/player_service.dart';

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/app_router.dart';
import 'package:poker_planning_client/app_config.dart';

import 'package:poker_planning_client/messages/handlers/player_kicked_handler.dart';
import 'package:poker_planning_client/messages/handlers/game_information_handler.dart';
import 'package:poker_planning_client/messages/handlers/game_reset_handler.dart';
import 'package:poker_planning_shared/messages/message_factory.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';

class PokerPlanningModule extends Module {
  PokerPlanningModule(String hostname, int port) {
    Logger.root
      ..onRecord.listen((LogRecord r) {
        print(r.message);
      });

    SocketCommunication socket = new SocketCommunication(hostname, port);
    socket.initWebSocket();

    bind(ApiPaths);
    bind(GameApiPaths);
    bind(PlayerApiPaths);
    bind(TimeApiPaths);
    bind(PlayerService);
    bind(TimeService);
    bind(GameService);
    bind(MessageFactory, toValue: new MessageFactory());
    bind(MessageHandlers,
        toFactory: (MessageFactory messageFactory, PlayerKickedHandler playerKickedHandler,
            GameHasResetHandler resetHandler, GameInformationHandler gameInformationHandler) {
      return new MessageHandlers(messageFactory, [playerKickedHandler, resetHandler, gameInformationHandler]);
    }, inject: [MessageFactory, PlayerKickedHandler, GameHasResetHandler, GameInformationHandler]);
    bind(Analytics);
    bind(SocketCommunication, toValue: socket);
    bind(Home);
    bind(HomeLogin);
    bind(GameCard);
    bind(GamePlayer);
    bind(GameComponent);
    bind(Lobby);
    bind(LobbyGame);
    bind(CurrentUser);
    bind(CurrentGame);
    bind(PlayerKickedHandler);
    bind(GameInformationHandler);
    bind(GameHasResetHandler);
    bind(RouteInitializerFn, toImplementation: AppRouter);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

main() async {
  AppConfig config = new AppConfig();
  config.config = await Config.loadConfig();
  var hostname = config.config["hostname"];
  var port = config.config["port"];
  var restPort = config.config["restPort"];
  if (hostname == null) throw ("hostname wasn't set in config.yaml");
  if (port == null) throw ("port wasn't set in config.yaml");
  if (restPort == null) throw ("restPort wasn't set in config.yaml");
  config.initConfig();

  applicationFactory()
      .addModule(new PokerPlanningModule(hostname, port)..bind(AppConfig, toValue: config))
      .addModule(new NodeBindModule())
      .run();
}
