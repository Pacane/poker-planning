library game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Component(
    selector: 'game-component',
    cssUrl: 'packages/poker_planning_client/components/game_component.css',
    templateUrl: 'packages/poker_planning_client/components/game_component.html')
class GameComponent implements ScopeAware, AttachAware, DetachAware {
  CurrentUser currentUser;
  Router router;
  SocketCommunication socketCommunication;
  Scope _scope;
  RouteProvider routeProvider;

  @NgOneWay("players")
  List<Tuple<String, String>> players = [];

  @NgOneWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser, this.router, this.socketCommunication, this.routeProvider);

  void revealOthersCards() => socketCommunication.sendSocketMsg({
      "revealAll": ""
  });

  void initReset() {
    socketCommunication.sendSocketMsg({
        "resetRequest": ""
    });
  }

  void gameHasReset() {
    players.forEach((t) => t.second = "");
    _scope.broadcast("game-has-reset", {});
  }

  void handleMessage(data) {
    if (_scope.isDestroyed) {
      return;
    }

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

  void updateCard(String player, String card) {
    if (!players.any((x) => x.first == player)) {
      players.add(new Tuple(player, card));
    } else {
      players.forEach((t) {
        if (t.first == player) {
          t.second = card;
          return;
        }
      });
    }
  }

  void displayCards(Map game, bool revealed) {
    print("display cards with revealed : $revealed");
    gameRevealed = revealed;

    removePlayersWhoLeft(game);

    game.forEach((String player, String card) {
      updateCard(player, card);
    });

    _scope.broadcast("card-update", [game, revealed]);
  }

  void removePlayersWhoLeft(Map game) {
    players.removeWhere((t) => !game.containsKey(t.first));
  }

  void kickPlayer(String player) {
    socketCommunication.sendSocketMsg({
        "kicked" : player
    });
  }

  void handleKick(Map kick) {
    String kicked = kick["kicked"];
    String kickedBy = kick["kickedBy"];

    players.removeWhere((p) => p.first == kicked);

    if (kicked == currentUser.userName) {
      var msg = "you have been kicked by: $kickedBy";
      _scope.rootScope.broadcast("kicked", msg);
    } else {
      print("$kicked has been kicked by $kickedBy");
    }
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("kick-player").listen((event) => kickPlayer(event.data));
  }

  void checkLogin() {
  }

  void attach() {
    var gameId = routeProvider.parameters['id'];

    var loginInfo = {
        'login' :
        {
            'gameId': gameId,
            'username': currentUser.userName
        }
    };


    socketCommunication.sendSocketMsg(loginInfo); // TODO: Change this to use REST API
    socketCommunication.ws.onMessage.listen((MessageEvent e) => handleMessage(e.data));
  }

  void detach() {
    players = [];
  }
}
