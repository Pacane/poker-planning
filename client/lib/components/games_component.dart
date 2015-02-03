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
    selector: 'games-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/games_component.html')
class GamesComponent implements ScopeAware, AttachAware, DetachAware, ShadowRootAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  ShadowRoot _shadowRoot;
  Config config;

  GamesComponent(this.currentUser, this.router, this.socketCommunication, this.config);

  void handleMessage(data) {
  }

  void set scope(Scope scope) {
    this._scope = scope;
  }

  void attach() {
    var hostname = config.config['hostname'];
    var restPort = config.config['restPort'];
    var url = "http://$hostname:$restPort/games";

    // call the web server asynchronously
    var request = HttpRequest.getString(url).then((value){
      var games = JSON.decode(value).map((map) => new Game.fromMap(map));
      games.forEach((Game game) => _shadowRoot.querySelector("#games").appendHtml("<li>${game.name}</li>"));
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
