library login_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../lib/current_user.dart';
import '../lib/socket_communication.dart';

@Component(
    selector: 'login-component',
    cssUrl: '../core.css',
    templateUrl: 'login_component.html')
class LoginComponent {
  CurrentUser session;
  SocketCommunication socketCommunication;

  LoginComponent(this.session, this.socketCommunication);

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = session.userName;
    querySelector("#loggedIn").classes.toggle("hidden", false);
  }

  void handleLoginClick(MouseEvent e) {
    InputElement nameInput = querySelector("#nameInput");
    String newName = nameInput.value;

    if (newName.isEmpty) return;

    session.userName = newName;

    onUserExists();
  }

  void onUserExists() {
    var loginInfo = {
        'login' : session.userName
    };

    socketCommunication.sendSocketMsg(loginInfo);

    hideLoginForm();
    showLoginSuccessful();
//    showGame();
  }

  void logout(String msg) {
    socketCommunication.close();
    window.alert(msg);
    session.logOffCurrentUser();
    window.location.reload();
  }

  void hideLoginForm() {
    querySelector("#login").remove();
  }
}
