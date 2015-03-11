library create_game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/config.dart';

import 'package:poker_planning_shared/game.dart';

@Component(
    selector: 'lobby-gameCreate',
    cssUrl: 'packages/poker_planning_client/css/layout.css',
    templateUrl: 'packages/poker_planning_client/components/lobby/lobby_game.html')
class LobbyGame implements ScopeAware, ShadowRootAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  ShadowRoot _shadowRoot;
  Config config;

  @NgTwoWay("gameName")
  String gameName;
  @NgTwoWay("password")
  String password;

  LobbyGame(this.currentUser, this.router, this.socketCommunication, this.config);

  void handleMessage(data) {}

  void set scope(Scope scope) {
    this._scope = scope;
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
  }

  void createGame() {
    var url = "http://${config.hostname}:${config.restPort}/games"; // TODO: Extract api's address

    HttpRequest
        .request(url,
            method: "PUT",
            requestHeaders: {'Content-type': 'application/json'},
            sendData: JSON.encode({"name": gameName})) // TODO: Wrap this
        .then((HttpRequest response) {
      if (response.status == 200) {
        // TODO: Find this constant
        var createdGame = JSON.decode(response.response);
        var gameId = createdGame["id"];
        router.go(Routes.GAMES, {"id": gameId});
      }
    });
  }
}
