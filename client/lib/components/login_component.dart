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
  RouteProvider routeProvider;
  String get previousRoute => routeProvider.parameters["sourceRoute"];

  LoginComponent(this._session, this._socketCommunication, this.routeProvider);

  void handleLoginClick() {
    InputElement nameInput = shadowRoot.querySelector("#nameInput");
    String newName = nameInput.value;

    if (newName.isEmpty) return;

    _session.userName = newName;
    _session.onUserExists(previousRoute);
  }

  void set scope(Scope scope) {
    _scope = scope;
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void attach() {
    if (previousRoute == null && _session.userName != null) {
      print("attached null route");
      _session.onUserExists(null);
    } else if (_session.userName == null) {
      _session.hideLoginStatus();
    }
  }
}
