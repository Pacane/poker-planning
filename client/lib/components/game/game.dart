library game_component;

import 'dart:html';
import 'dart:js';
import 'dart:convert';
import 'dart:async';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/services/game_service.dart';
import 'package:poker_planning_client/services/time_service.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/app_config.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/login_event.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';
import 'package:poker_planning_shared/messages/reveal_request_event.dart';
import 'package:poker_planning_shared/messages/reset_game_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';

import 'package:poker_planning_shared/player.dart';

import "package:logging/logging.dart";

@Component(
    selector: 'game',
    cssUrl: 'packages/poker_planning_client/components/game/game.css',
    templateUrl: 'packages/poker_planning_client/components/game/game.html')
class GameComponent implements ScopeAware, AttachAware, DetachAware, ShadowRootAware {
  GameService gameService;
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  CurrentGame currentGame;
  RouteProvider routeProvider;
  AppConfig config;
  Logger logger = Logger.root;
  MessageHandlers messageHandlers;
  ShadowRoot shadowRoot;
  Analytics analytics;
  bool connected = false;
  TimeService timeService;
  Duration timeDifference;

  @NgOneWay("players")
  List<Tuple<Player, String>> players;

  @NgTwoWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser, this.router, this.socketCommunication, this.currentGame, this.routeProvider,
      this.config, this.messageHandlers, this.analytics, this.gameService, this.timeService) {
    players = currentGame.players;
  }

  void revealOthersCards() {
    socketCommunication.sendSocketMsg(new RevealRequestEvent(currentGame.getGameId()));
    analytics.sendEvent("Game", "Reveal", currentGame.getGameId().toString());
  }

  void initReset() {
    socketCommunication.sendSocketMsg(new ResetGameEvent(currentGame.getGameId()));
  }

  void handleMessage(data) {
    if (_scope.isDestroyed) {
      return;
    }

    var decoded = JSON.decode(data);

    messageHandlers.handleMessage(decoded);
  }

  void kickPlayer(int playerId) {
    socketCommunication.sendSocketMsg(new KickEvent(currentGame.getGameId(), playerId, currentUser.userId));
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("kick-player").listen((event) => kickPlayer(event.data));
    scope.on("game-update").listen((event) {
      gameRevealed = event.data;
    });
  }

  Future attach() async {
    connected = false;

    currentGame.setGameId(routeProvider.parameters['id']);

    bool gameExists = await gameService.gameExists(currentGame.getGameId());

    if (!gameExists) {
      router.go(Routes.GAMES, {});
    } else {
      await askForGamePassword();

      timeService.getTimeDifference().then((Duration difference) {
        timeDifference = difference;
        new Timer.periodic(new Duration(milliseconds: 500), handleTimer);
      });

      await currentUser.createPlayer();

      socketCommunication.sendSocketMsg(new LoginEvent(currentGame.getGameId(), currentUser.userId));
      socketCommunication.ws.onMessage.listen((MessageEvent e) => handleMessage(e.data));

      connected = true;

      window.onBeforeUnload.listen((event) {
        _sendDisconnectEvent();
      });
    }
  }

  Future askForGamePassword() async {
    bool isGameProtected = await gameService.isGameProtected(currentGame.getGameId());
    if (isGameProtected) {
      String password = context.callMethod('prompt', ['Please enter the game password', '']);
      bool canEnter = await gameService.isPasswordValid(currentGame.getGameId(), password);
      if (!canEnter) {
        router.go(Routes.GAMES, {});
      }
    }
  }

  void handleTimer(Timer t) {
    if (currentGame.lastReset == null) {
      return;
    }
    shadowRoot.querySelector("#lastReset").text =
        timeService.getFormattedRemainingTime(new DateTime.now().difference(currentGame.lastReset));
  }

  void detach() {
    players = [];

    if (connected) {
      _sendDisconnectEvent();
    }

    currentGame.resetGameId();
  }

  _sendDisconnectEvent() {
    socketCommunication.sendSocketMsg(new DisconnectEvent(currentGame.getGameId(), currentUser.userId));
    currentUser.leftGame();
  }
}
