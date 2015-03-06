library game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/config.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/login_event.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';
import 'package:poker_planning_shared/messages/reveal_request_event.dart';
import 'package:poker_planning_shared/messages/game_reset_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handlers.dart';

import "package:logging/logging.dart";

@Component(
    selector: 'game',
    cssUrl: 'packages/poker_planning_client/components/game/game.css',
    templateUrl: 'packages/poker_planning_client/components/game/game.html')
class GameComponent implements ScopeAware, AttachAware, DetachAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  CurrentGame currentGame;
  RouteProvider routeProvider;
  Config config;
  Logger logger = Logger.root;
  MessageHandlers messageHandlers;

  @NgOneWay("players")
  List<Tuple<String, String>> players;

  @NgTwoWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser,
                this.router,
                this.socketCommunication,
                this.currentGame,
                this.routeProvider,
                this.config,
                this.messageHandlers) {
    players = currentGame.players;
  }

  void revealOthersCards() => socketCommunication.sendSocketMsg(new RevealRequestEvent(currentGame.getGameId()));

  void initReset() {
    socketCommunication.sendSocketMsg(new GameResetEvent(currentGame.getGameId()));
  }

  void gameHasReset() {
    gameRevealed = false;
    currentGame.players.forEach((t) => t.second = "");
    _scope.broadcast("game-has-reset", {});
  }

  void handleMessage(data) {
    if (_scope.isDestroyed) {
      return;
    }

    var decoded = JSON.decode(data);

    messageHandlers.handleMessage(decoded);
  }

  void kickPlayer(String player) {
    socketCommunication.sendSocketMsg(
        new KickEvent(currentGame.getGameId(), player, currentUser.userName));
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("kick-player").listen((event) => kickPlayer(event.data));
    scope.on("game-update").listen((event){
      gameRevealed = event.data;
    });
  }

  void checkIfGameExists() {
    var url = "http://${config.hostname}:${config.restPort}/games/${currentGame.getGameId()}"; // TODO: Extract route

    HttpRequest httpRequest = new HttpRequest();
    httpRequest
      ..open('GET', url)
      ..onLoadEnd.listen((_) {
        var status = httpRequest.status;
        if (status == 404) {
          router.go(Routes.GAMES, {});
        }
      })..send();
  }

  void attach() {
    currentGame.setGameId(routeProvider.parameters['id']);

    checkIfGameExists();

    socketCommunication.sendSocketMsg(new LoginEvent(currentGame.getGameId(), currentUser.userName));
    socketCommunication.ws.onMessage.listen((MessageEvent e) => handleMessage(e.data));
    window.onBeforeUnload.listen((event){
      socketCommunication.sendSocketMsg(new DisconnectEvent(currentGame.getGameId(), currentUser.userName));
    });
}

  void detach() {
    players = [];

    currentGame.resetGameId();
  }
}
