library login_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Component(
    selector: 'login-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/login_component.html')
class LoginComponent implements ScopeAware, ShadowRootAware, AttachAware {
  ShadowRoot shadowRoot;
  CurrentUser _session;
  SocketCommunication _socketCommunication;
  Scope _scope;
  Router _router;

  LoginComponent(this._session, this._socketCommunication, this._router);

  void showLoginSuccessful() {
    querySelector("#nameSpan").text = _session.userName;
    querySelector("#loggedIn").classes.remove("hidden");
  }

  void handleLoginClick() {
    InputElement nameInput = shadowRoot.querySelector("#nameInput");
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

    showLoginSuccessful();

    _router.go("game", {});
  }

  void logout(String msg) {
    _socketCommunication.close();
    window.alert(msg);
    _session.logOffCurrentUser();
    window.location.reload();
  }

  void set scope(Scope scope) {
   _scope = scope;
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void attach() {
    if (_session.userName != null) {
      onUserExists();
    }
  }
}
