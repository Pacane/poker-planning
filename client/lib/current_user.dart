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
    scope.on("check-login").listen((ScopeEvent event) {
      String sourceRoute = event.data.length == 0 ? "" : event.data[0];
      print("source route: $sourceRoute");

      if (userName == null) {
        router.go(Routes.LOGIN, {"source" : sourceRoute});
      } else {
        onUserExists(sourceRoute);
      }
    });
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

  void onUserExists(String sourceRoute) {
    var loginInfo = {'login' : userName};

    socketCommunication.sendSocketMsg(loginInfo);

    showLoginSuccessful();

    if (sourceRoute != "") {
      router.go(sourceRoute, {});
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
}
