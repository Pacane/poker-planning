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
    scope.on("kicked").listen((event) => logout(event.data));
  }

  String get userName => localStorage['username'];

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
    } else {
      router.go(Routes.GAMES, {});
    }
  }

  void logout(String msg) {
    window.alert(msg);
    socketCommunication.sendSocketMsg({"disconnect" : userName});
    logOffCurrentUser();
    router.go(Routes.ROOT, {});
  }

  void checkLogin(String sourceRoute) {
      if (userName == null) {
        hideLoginStatus();
        print("Cannot access $sourceRoute, sending back to login.");
        router.go("login", {"sourceRoute" : sourceRoute});
      } else {
        showLoginSuccessful();
      }
    }
}
