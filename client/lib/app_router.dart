library grocery_store_routing;

import 'package:angular/angular.dart';
import 'dart:async';

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/socket_communication.dart';

import 'package:poker_planning_client/routes.dart';

import "package:logging/logging.dart";

@Injectable()
class AppRouter implements Function {
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope scope;
  CurrentGame currentGame;
  Logger logger = Logger.root;
  Analytics analytics;

  AppRouter(this.socketCommunication, this.currentUser, this.scope, this.currentGame, this.analytics);

  Future<bool> checkLogin(String sourceRoute, [List<Route> activePath, Map parameters]) async {
    if (parameters == null && activePath != null && !activePath.isEmpty) {
      parameters = activePath.last.parameters;
    } else if (parameters == null) {
      parameters = {};
    }

    return new Future.value(currentUser.checkLogin(sourceRoute, parameters));
  }

  void logout(Router router) {
    currentUser.logOffCurrentUser();
    analytics.sendEvent("Site", "Logout");
    router.go(Routes.ROOT, {});
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
      Routes.LOGOUT: ngRoute(path: Routes.toPath('${Routes.LOGOUT}'), enter: (_) => logout(router)),
      'login_without_params': ngRoute(
          path: Routes.toPath('${Routes.LOGIN}'),
          view: 'view/home.html',
          enter: (_) => analytics.sendPageView(Routes.toPath(Routes.LOGIN))),
      'login_without_id': ngRoute(
          path: Routes.toPath('${Routes.LOGIN}/:sourceRoute'),
          view: 'view/home.html',
          enter: (_) => analytics.sendPageView(Routes.toPath(Routes.LOGIN))),
      Routes.LOGIN: ngRoute(
          path: Routes.toPath('${Routes.LOGIN}/:sourceRoute/:id'),
          view: 'view/home.html',
          enter: (_) => analytics.sendPageView(Routes.toPath(Routes.LOGIN)),
          preEnter: (RoutePreEnterEvent e) {
        if (e.parameters['id'] == 'null') {
          router.go('login_without_id', e.parameters, replace: true, forceReload: true);
        }
      }),
      Routes.GAMES: ngRoute(path: Routes.toPath('${Routes.GAMES}/:id'), view: 'view/game.html', enter: (e) {
        analytics.sendPageView('/game');
        analytics.sendEvent('Game', 'Enter', e.parameters['id']);
      }, preEnter: (RoutePreEnterEvent e) {
        if (e.parameters['id'] == 'null') {
          router.go('lobby', e.parameters, replace: true);
        } else {
          e.allowEnter(checkLogin(Routes.GAMES, router.activePath, e.parameters));
        }
      }),
      'lobby': ngRoute(
          path: Routes.toPath(Routes.GAMES),
          view: 'view/lobby.html',
          enter: (_) => analytics.sendPageView(Routes.toPath(Routes.GAMES)),
          preEnter: (RoutePreEnterEvent e) => e.allowEnter(checkLogin(Routes.GAMES, router.activePath))),
      Routes.ROOT:
          ngRoute(path: '/', view: 'view/home.html', enter: (_) => analytics.sendPageView('/'), defaultRoute: true)
    });
  }
}
