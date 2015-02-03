library game_component;

import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
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
  CurrentGame currentGame;
  RouteProvider routeProvider;

  @NgOneWay("players")
  List<Tuple<String, String>> players = [];

  @NgOneWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser, this.router, this.socketCommunication, this.currentGame, this.routeProvider);

  void revealOthersCards() => socketCommunication.sendSocketMsg({
      "revealAll": currentGame.getGameId()
  });

  void initReset() {
    socketCommunication.sendSocketMsg({
        "resetRequest": currentGame.getGameId()
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
    var reset = decoded["gameHasReset"];
    Map kick = decoded["kick"];
    var gameId = decoded['gameId'];

    if (game != null) {
      if (gameId != currentGame.getGameId()) {
        return;
      }
      displayCards(game, false);
    } else if (revealedGame != null) {
      if (gameId != currentGame.getGameId()) {
        return;
      }
      displayCards(revealedGame, true);
    } else if (reset != null) {
      if (reset != currentGame.getGameId()) {
        return;
      }
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
        "kicked" : [player, currentUser.userName, currentGame.getGameId()]
    });
  }

  void handleKick(Map kick) {
    String kicked = kick["kicked"];
    String kickedBy = kick["kickedBy"];
    int gameId = kick["gameId"];
    if (gameId != currentGame.getGameId()) {
      return;
    }

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

  void attach() {
    currentGame.setGameId(routeProvider.parameters['id']);

    var loginInfo = {
        'login' :
        {
            'gameId': currentGame.getGameId(),
            'username': currentUser.userName
        }
    };

    socketCommunication.sendSocketMsg(loginInfo);
    socketCommunication.ws.onMessage.listen((MessageEvent e) => handleMessage(e.data));
  }

  void detach() {
    players = [];
    socketCommunication.sendSocketMsg({"disconnect":[currentUser.userName, currentGame.getGameId()]});
    currentGame.resetGameId();
  }
}
