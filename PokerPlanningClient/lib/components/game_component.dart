library game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Component(
    selector: 'game-component',
    cssUrl: 'packages/poker_planning_client/components/game_component.css',
    templateUrl: 'packages/poker_planning_client/components/game_component.html')
class GameComponent implements ScopeAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;

  @NgTwoWay("players")
  Map<String, String> players = {
  };

  @NgTwoWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser, this.router, this.socketCommunication) {
    socketCommunication.ws.onMessage.listen((MessageEvent e) => handleMessage(e.data));
  }

  void revealOthersCards(_) => socketCommunication.sendSocketMsg({
      "revealAll": ""
  });

  void initReset(_) {
    socketCommunication.sendSocketMsg({
        "resetRequest": ""
    });
  }

  void gameHasReset() {
    _scope.broadcast("game-has-reset", {
    });
  }

  void showGame() {
    querySelector("#revealOthersCards").onClick.listen(revealOthersCards);
    querySelector("#reset").onClick.listen(initReset);
  }

  void handleMessage(data) {
    var decoded = JSON.decode(data);

    Map game = decoded["game"];
    Map revealedGame = decoded["revealedGame"];
    String reset = decoded["gameHasReset"];
    Map kick = decoded["kick"];

    if (game != null) {
      displayCards(game, false);
    } else if (revealedGame != null) {
      displayCards(revealedGame, true);
    } else if (reset != null) {
      print("Game has reset!");
      gameHasReset();
    } else if (kick != null) {
      handleKick(kick);
    }
  }

  void displayCards(Map game, bool revealed) {
    print("display cards with revealed : $revealed");
    var othersCardDiv = querySelector("#othersCards")
      ..innerHtml = "";

    players.clear();
    gameRevealed = revealed;
    game.forEach((String player, String card) {
      players[player] = card;
    });
  }

  void kickPlayer(String player) {
    socketCommunication.sendSocketMsg({
        "kicked" : player
    });
  }

  void handleKick(Map kick) {
//  String kicked = kick["kicked"];
//  String kickedBy = kick["kickedBy"];
//
//  if (kicked == myName) {
//    var msg = "you have been kicked by: $kickedBy";
//    logout(msg);
//  } else {
//    print("$kicked has been kicked by $kickedBy");
//  }
  }

  void set scope(Scope scope) {
    this._scope = scope;
    checkLogin();
  }

  void checkLogin() {
    print("check login");
    _scope.rootScope.broadcast("check-login", []);
  }
}
