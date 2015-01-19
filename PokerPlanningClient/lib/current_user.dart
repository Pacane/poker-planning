import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/socket_communication.dart';

@Injectable()
class CurrentUser {
  Router router;
  SocketCommunication socketCommunication;
  Storage localStorage = window.localStorage;
  Scope scope;

  CurrentUser(this.router, this.socketCommunication, this.scope) {
    scope.on("check-login").listen((_) {
      if(userName == null) {
        router.go("login", {});
      } else {
        onUserExists();
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
  }

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = userName;
    querySelector("#loggedIn").classes.remove("hidden");
  }

  void onUserExists() {
    var loginInfo = {
        'login' : userName
    };

    socketCommunication.sendSocketMsg(loginInfo);

    showLoginSuccessful();

    router.go("game", {});
  }

  void logout(String msg) {
    window.alert(msg);
    logOffCurrentUser();
    router.go("root", {});
  }
}
