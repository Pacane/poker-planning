library login_component;

import 'dart:html';

import 'package:angular/angular.dart';

import '../lib/current_user.dart';
import '../lib/socket_communication.dart';

@Component(
    selector: 'login-component',
    cssUrl: '../core.css',
    templateUrl: 'login_component.html')
class LoginComponent implements ScopeAware {
  CurrentUser _session;
  SocketCommunication _socketCommunication;
  Scope _scope;
  Router _router;

  LoginComponent(this._session, this._socketCommunication, this._router) {
    print(_router);
  }

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = _session.userName;
    querySelector("#loggedIn").classes.toggle("hidden", false);
  }

  void handleLoginClick() {
    InputElement nameInput = querySelector("#nameInput");
    String newName = nameInput.value;

    if (newName.isEmpty) return;

    _session.userName = newName;

    onUserExists();
  }

  void onUserExists() {
    var loginInfo = {
        'login' : _session.userName
    };

    _socketCommunication.sendSocketMsg(loginInfo);

    hideLoginForm();
    showLoginSuccessful();

    _router.gotoUrl("http://google.ca");
  }

  void logout(String msg) {
    _socketCommunication.close();
    window.alert(msg);
    _session.logOffCurrentUser();
    window.location.reload();
  }

  void hideLoginForm() {
    querySelector("#login").remove();
  }

  void set scope(Scope scope) {
   _scope = scope;
  }
}
