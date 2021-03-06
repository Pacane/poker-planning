library create_game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:quiver/strings.dart' as quiver;

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/app_config.dart';

@Component(
    selector: 'lobby-gameCreate',
    cssUrl: 'packages/poker_planning_client/css/layout.css',
    templateUrl: 'packages/poker_planning_client/components/lobby/lobby_game.html')
class LobbyGame {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Analytics analytics;
  AppConfig config;

  @NgTwoWay("gameName")
  String gameName;
  @NgTwoWay("password")
  String password;

  LobbyGame(this.currentUser, this.router, this.socketCommunication, this.config, this.analytics);

  void handleMessage(data) {}

  void createGame() {
    var url = "http://${config.hostname}:${config.restPort}/games"; // TODO: Extract api's address

    HttpRequest
        .request(url,
            method: "POST",
            requestHeaders: {'Content-type': 'application/json'},
            sendData: JSON.encode({"name": gameName, "password": quiver.emptyToNull(password)})) // TODO: Wrap this
        .then((HttpRequest response) {
      if (response.status == 200) {
        // TODO: Find this constant
        var createdGame = JSON.decode(response.response);
        var gameId = createdGame["id"];
        router.go(Routes.GAMES, {"id": gameId});
        analytics.sendEvent("Game", "Create", gameId.toString());
        router.go(Routes.GAMES, {"id" : gameId});
      }
    });
  }
}
