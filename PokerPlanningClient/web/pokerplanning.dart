library poker_planning;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'components/my_card.dart';
import 'components/table_card.dart';
import 'components/login_component.dart';
import 'lib/socket_communication.dart';
import 'lib/current_user.dart';

import 'package:dart_config/default_browser.dart' as Config;
import 'package:polymer/polymer.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

class MyAppModule extends Module {
  MyAppModule() {
    bind(SocketCommunication, toValue: new SocketCommunication(hostname, port));
    print("Socket bound with: $hostname $port");
    bind(LoginComponent);
    bind(CurrentUser);
  }
}

Map<String, String> players = {
};

WebSocket ws;
var hostname;
var port;
SocketCommunication socketCommunication;


void main() {
  Config.loadConfig().then((Map config) {
    hostname = config["hostname"];
    port = config["port"];
    if (hostname == null) throw("hostname wasn't set in config.yaml");
    if (port == null) throw("port wasn't set in config.yaml");
  }).then((_) {
    initPolymer();

    applicationFactory()
    .addModule(new MyAppModule())
    .run();
  });
}

void showError(error) => querySelector("#error").appendHtml("$error.toString() <br>");

void hideLoginForm() {
  querySelector("#login").remove();
}

void showGame() {
  querySelector("#game").classes.toggle("hidden", false);
  querySelector("#myCards")
    ..innerHtml = "<div class=\"cardsContainer\"><div class=\"card cardSpacer\"></div></div>"
    ..append(new MyCard("0", selectCard))
    ..append(new MyCard("½", selectCard))
    ..append(new MyCard("1", selectCard))
    ..append(new MyCard("2", selectCard))
    ..append(new MyCard("3", selectCard))
    ..append(new MyCard("5", selectCard))
    ..append(new MyCard("8", selectCard))
    ..append(new MyCard("13", selectCard))
    ..append(new MyCard("20", selectCard))
    ..append(new MyCard("40", selectCard))
    ..append(new MyCard("∞", selectCard))
    ..append(new MyCard("?", selectCard))
    ..append(new MyCard("Pause", selectCard))
  ;

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

void selectCard(String value) {
  sendSocketMsg({
      "cardSelection": [myName, value]
  });
}

outputMsg(String msg) {
  print(msg);
}

onSocketOpen(event) {
  outputMsg('Connected');

//  if (myName == null) {
//    querySelector("#loginButton").onClick.listen(handleLoginClick);
//  } else {
//    onUserExists();
//  }
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
