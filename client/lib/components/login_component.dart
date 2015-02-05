library login_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Component(
    selector: 'login-component',
    cssUrl: 'packages/poker_planning_client/components/css/_layout.css',
    templateUrl: 'packages/poker_planning_client/components/login_component.html')
class LoginComponent implements ScopeAware, ShadowRootAware, AttachAware {
  ShadowRoot shadowRoot;
  Router router;
  CurrentUser _session;
  SocketCommunication _socketCommunication;
  Scope _scope;
  RouteProvider routeProvider;
  String get previousRoute => routeProvider.parameters["sourceRoute"];

  LoginComponent(this._session, this._socketCommunication, this.router, this.routeProvider);

  start() => router.go(Routes.GAMES, {});

  void handleLoginClick() {
    InputElement nameInput = shadowRoot.querySelector("#nameInput");
    String newName = nameInput.value;

    if (newName.isEmpty) return;

    _session.userName = newName;
    _session.onUserExists(previousRoute);

    checkDisplayState();
  }

  void set scope(Scope scope) {
    _scope = scope;
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
    checkDisplayState();
  }

  void checkDisplayState() {
    shadowRoot.querySelector(".is-logout").classes.toggle("hidden", _session.userExists);
    shadowRoot.querySelector(".is-login").classes.toggle("hidden", !_session.userExists);
    shadowRoot.querySelector(".js-show-name").text = _session.userName;
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
