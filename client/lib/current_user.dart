import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/routes.dart';

@Injectable()
class CurrentUser {
  Router router;
  SocketCommunication socketCommunication;
  Storage localStorage = window.localStorage;
  Scope scope;

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
    querySelector("#nameSpan").text = userName;
    querySelector("#loggedIn").classes.add("hidden");
  }

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = userName;
    querySelector("#loggedIn").classes.remove("hidden");
  }

  void hideLoginStatus() {
    querySelector("#nameSpan").text = "";
    querySelector("#loggedIn").classes.add("hidden");
  }

  void onUserExists(String sourceRoute) {
    print("source route: $sourceRoute");

    showLoginSuccessful();

    if (sourceRoute != null) {
      router.go(sourceRoute, {}, forceReload: true);
    }
  }

  void sendBackToGames(String msg) {
    window.alert(msg);
    router.go(Routes.GAMES, {});
  }

  void checkLogin(String sourceRoute) {
    print(sourceRoute);
    if (userName == null) {
      hideLoginStatus();
      print("Cannot access $sourceRoute, sending back to login.");
      router.go(Routes.ROOT, {"sourceRoute" : sourceRoute});
    } else {
      showLoginSuccessful();
    }
  }
}
