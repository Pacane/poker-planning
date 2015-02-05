library games_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/config.dart';

import 'package:poker_planning_shared/game.dart';

@Component(
    selector: 'lobby',
    cssUrl: 'packages/poker_planning_client/components/lobby/lobby.css',
    templateUrl: 'packages/poker_planning_client/components/lobby/lobby.html')
class GamesComponent implements ScopeAware, AttachAware, DetachAware, ShadowRootAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  ShadowRoot _shadowRoot;
  Config config;
  @NgTwoWay("games")
  List<Game> games;

  GamesComponent(this.currentUser, this.router, this.socketCommunication, this.config);

  void handleMessage(data) {
  }

  void set scope(Scope scope) {
    this._scope = scope;
  }

  void attach() {
    var url = "http://${config.hostname}:${config.restPort}/games"; // TODO: Extract route
    var request = HttpRequest.getString(url).then((value){
      games = JSON.decode(value).map((map) => new Game.fromMap(map)).toList();
    });
  }

  void detach() {
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
  }

  void createGame() {
    router.go(Routes.NEW_GAME, {});
  }
}
