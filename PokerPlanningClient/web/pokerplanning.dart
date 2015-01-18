library poker_planning;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'package:poker_planning_client/components/my_card.dart';
import 'package:poker_planning_client/components/table_card.dart';
import 'package:poker_planning_client/components/login_component.dart';
import 'package:poker_planning_client/components/game_component.dart';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/app_router.dart';

import 'package:dart_config/default_browser.dart' as Config;

import 'package:angular_node_bind/angular_node_bind.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

class MyAppModule extends Module {
  MyAppModule() {
    bind(SocketCommunication, toValue: new SocketCommunication(hostname, port));
    bind(LoginComponent);
    bind(MyCard);
    bind(TableCard);
    bind(GameComponent);
    bind(CurrentUser);
    bind(RouteInitializerFn, toValue: routeInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

WebSocket ws;
var hostname;
var port;
SocketCommunication socketCommunication;
Map<String, String> players = {
};

main() async {
  Map config = await Config.loadConfig();
  hostname = config["hostname"];
  port = config["port"];
  if (hostname == null) throw("hostname wasn't set in config.yaml");
  if (port == null) throw("port wasn't set in config.yaml");

  applicationFactory()
  .addModule(new MyAppModule())
  .addModule(new NodeBindModule())
  .run();
}

void showError(error) => querySelector("#error").appendHtml("$error.toString() <br>");

void hideLoginForm() {
  querySelector("#login").remove();
}

void showGame() {
// TODO
  querySelector("#revealOthersCards").onClick.listen(revealOthersCards);
  querySelector("#reset").onClick.listen(initReset);
}

void revealOthersCards(_) => sendSocketMsg({
    "revealAll": ""
});

void initReset(_) {
  sendSocketMsg({
      "resetRequest": ""
  });
}

void gameHasReset() {
  MyCard.clearSelectedCards();
}

outputMsg(String msg) {
  print(msg);
}

void handleMessage(data) {
  print(data);

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

  game.forEach((player, card) {
    TableCard tableCard = new TableCard.create(player, card, revealed, kickPlayer);
    othersCardDiv.append(tableCard);
  });
}

void sendSocketMsg(Object jsObject) {
  ws.send(JSON.encode(jsObject));
}

void kickPlayer(String player) {
  sendSocketMsg({
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
