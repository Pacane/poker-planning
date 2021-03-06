library login_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/current_user.dart';

import "package:logging/logging.dart";

@Component(
    selector: 'home-login',
    cssUrl: 'packages/poker_planning_client/css/layout.css',
    templateUrl: 'packages/poker_planning_client/components/home/home_login.html')
class HomeLogin implements ShadowRootAware, AttachAware {
  ShadowRoot shadowRoot;
  Router router;
  CurrentUser _session;
  RouteProvider routeProvider;
  Logger logger = Logger.root;
  Analytics analytics;

  String get previousRoute {
    if (_parameters != null) {
      return _parameters["sourceRoute"];
    } else {
      return null;
    }
  }

  Map<String, String> get _parameters {
    if (!router.activePath.isEmpty) {
      return router.activePath.last.parameters;
    } else {
      return null;
    }
  }

  HomeLogin(this._session, this.router, this.routeProvider, this.analytics);

  start([String route = Routes.GAMES, Map parameters]) {
    if (parameters == null) {
      parameters = {};
    }

    router.go(route, parameters);
  }

  void handleLoginClick() {
    InputElement nameInput = shadowRoot.querySelector("#nameInput");
    String newName = nameInput.value;

    analytics.sendEvent("Site", "Login");

    if (newName.isEmpty) return;

    _session.userName = newName;
    _session.onUserExists(previousRoute, _parameters);

    checkDisplayState();
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
      logger.info("attached null route");
      _session.onUserExists(Routes.GAMES, {});
    } else if (_session.userName == null) {
      _session.hideLoginStatus();
    }
  }
}
