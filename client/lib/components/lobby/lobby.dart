library games_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

import 'package:poker_planning_client/config.dart';

import 'package:poker_planning_shared/game.dart';

@Component(
    selector: 'lobby',
    cssUrl: 'packages/poker_planning_client/components/lobby/lobby.css',
    templateUrl: 'packages/poker_planning_client/components/lobby/lobby.html')
class Lobby implements AttachAware {
  CurrentUser currentUser;
  SocketCommunication socketCommunication;
  Config config;
  @NgTwoWay("games")
  List<Game> games;

  Lobby(this.currentUser, this.socketCommunication, this.config);

  void attach() {
    var url = "http://${config.hostname}:${config.restPort}/games"; // TODO: Extract route
    HttpRequest.getString(url).then((value) {
      games = JSON.decode(value).map((map) => new Game.fromMap(map)).toList();
    });
  }
}
