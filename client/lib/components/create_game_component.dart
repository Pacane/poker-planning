library create_game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';

import 'package:poker_planning_shared/game.dart';

@Component(
    selector: 'create-game-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/create_game_component.html')
class CreateGameComponent implements ScopeAware, AttachAware, DetachAware, ShadowRootAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  ShadowRoot _shadowRoot;

  @NgTwoWay("gameName")
  String gameName;
  @NgTwoWay("password")
  String password;

  CreateGameComponent(this.currentUser, this.router, this.socketCommunication);

  void handleMessage(data) {
  }

  void set scope(Scope scope) {
    this._scope = scope;
    _scope.rootScope.broadcast("check-login", [Routes.NEW_GAME]);
  }

  void attach() {
//    var url = "http://localhost:3010/games";
//
//    // call the web server asynchronously
//    var request = HttpRequest.getString(url).then((value){
//      var games = JSON.decode(value).map((map) => new Game.fromMap(map));
//      games.forEach((Game game) => _shadowRoot.querySelector("#games").appendHtml("<li>${game.test}</li>"));
//    });
  }

  void detach() {
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
  }
}
