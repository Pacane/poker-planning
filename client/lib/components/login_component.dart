library login_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Component(
    selector: 'login-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/login_component.html')
class LoginComponent implements ScopeAware, ShadowRootAware {
  ShadowRoot shadowRoot;
  CurrentUser _session;
  SocketCommunication _socketCommunication;
  Scope _scope;

  LoginComponent(this._session, this._socketCommunication);

  void handleLoginClick() {
    InputElement nameInput = shadowRoot.querySelector("#nameInput");
    String newName = nameInput.value;

    if (newName.isEmpty) return;

    _session.userName = newName;
    _session.onUserExists("");
  }

  void set scope(Scope scope) {
    _scope = scope;
    _scope.rootScope.broadcast("check-login", []);
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }
}
