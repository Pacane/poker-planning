library current_user;

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';

import "package:logging/logging.dart";

@Injectable()
class CurrentUser {
  Router router;
  SocketCommunication socketCommunication;
  Storage localStorage = window.localStorage;
  Scope scope;
  Logger logger = Logger.root;

  CurrentUser(this.router, this.socketCommunication, this.scope) {
    scope.on("kicked").listen((event) => sendBackToGames(event.data));
  }

  String get userName => localStorage['username'];

  bool get userExists => userName != null;

  void set userName(String userName) {
    localStorage['username'] = userName;
  }

  void logOffCurrentUser() {
    localStorage.remove('username');
    hideLoginStatus();
  }

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = userName;
    querySelector("#loggedIn").classes.remove("hidden");
  }

  void hideLoginStatus() {
    querySelector("#nameSpan").text = "";
    querySelector("#loggedIn").classes.add("hidden");
  }

  void onUserExists(String sourceRoute, Map parameters) {
    logger.fine("source route: $sourceRoute");

    showLoginSuccessful();

    if (sourceRoute != null) {
      router.go(sourceRoute, parameters, forceReload: true);
    }
  }

  void sendBackToGames(String msg) {
    window.alert(msg);
    router.go(Routes.GAMES, {}, replace: true, forceReload: true);
  }

  bool checkLogin(String sourceRoute, Map parameters) {
    if (userName == null) {
      hideLoginStatus();
      logger.info("Cannot access $sourceRoute, sending back to login.");

      parameters["sourceRoute"] = sourceRoute;

      new Future.delayed(new Duration(milliseconds:10),
          () => router.go(Routes.LOGIN, parameters, replace: true, forceReload:true));
      return false;
    } else {
      showLoginSuccessful();
      return true;
    }
  }
}
