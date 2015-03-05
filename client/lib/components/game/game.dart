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
import 'package:poker_planning_client/messages/handlers/kick_event_handler.dart';

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/login_event.dart';
import 'package:poker_planning_shared/messages/disconnect_event.dart';
import 'package:poker_planning_shared/messages/message_factory.dart';
import 'package:poker_planning_shared/messages/message.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';

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
  List<MessageHandler> messageHandlers = [];

  @NgOneWay("players")
  List<Tuple<String, String>> players;

  @NgOneWay("gameRevealed")
  bool gameRevealed;

  GameComponent(this.currentUser, this.router, this.socketCommunication, this.currentGame, this.routeProvider, this.config, KickEventHandler kickHandler) {
    players = currentGame.players;
    messageHandlers = [kickHandler];
  }

  void revealOthersCards() => socketCommunication.sendSocketMsg({
      "revealAll": currentGame.getGameId()
  });

  void initReset() {
    socketCommunication.sendSocketMsg({
        "resetRequest": currentGame.getGameId()
    });
  }

  void gameHasReset() {
    currentGame.players.forEach((t) => t.second = "");
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
    var gameId = decoded['gameId'];

    MessageFactory factory = new MessageFactory();
    Message message = factory.create(decoded);
    if (message != null) {
      messageHandlers.forEach((MessageHandler handler) => handler.tryHandlingMessage(message));
    }

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
      logger.info("Game has reset!");
      gameHasReset();
    }
  }

  void updateCard(String player, String card) {
    if (!currentGame.players.any((x) => x.first == player)) {
      currentGame.players.add(new Tuple(player, card));
    } else {
      currentGame.players.forEach((t) {
        if (t.first == player) {
          t.second = card;
          return;
        }
      });
    }
  }

  void displayCards(Map game, bool revealed) {
    logger.info("display cards with revealed : $revealed");
    gameRevealed = revealed;

    removePlayersWhoLeft(game);

    game.forEach((String player, String card) {
      updateCard(player, card);
    });

    _scope.broadcast("card-update", [game, revealed]);
  }

  void removePlayersWhoLeft(Map game) {
    currentGame.players.removeWhere((t) => !game.containsKey(t.first));
  }

  void kickPlayer(String player) {
    socketCommunication.sendSocketMsg(
        new KickEvent(currentGame.getGameId(), player, currentUser.userName).toJson());
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("kick-player").listen((event) => kickPlayer(event.data));
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
  }

  void detach() {
    players = [];
    socketCommunication.sendSocketMsg(new DisconnectEvent(currentGame.getGameId(), currentUser.userName));

    currentGame.resetGameId();
  }
}
