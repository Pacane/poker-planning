library grocery_store_routing;

import 'package:angular/angular.dart';
import 'dart:js';
import 'dart:async';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/socket_communication.dart';

import 'package:poker_planning_client/routes.dart';

@Injectable()
class AppRouter implements Function {
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope scope;
  CurrentGame currentGame;

  AppRouter(this.socketCommunication, this.currentUser, this.scope, this.currentGame);

  Future<bool> checkLogin(String sourceRoute, [List<Route> activePath, Map parameters]) {
    if (parameters == null && activePath != null && !activePath.isEmpty) {
      parameters = activePath.last.parameters;
    } else if (parameters == null) {
      parameters = {};
    }

    return new Future.value(currentUser.checkLogin(sourceRoute, parameters));
  }

  void logout() {
    print("LOGGING OUT ALMOST");
  }

  void sendGoogleAnalyticsPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
        'login_without_params': ngRoute(
            path: Routes.toPath('${Routes.LOGIN}'),
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
        ),
        'login_without_id': ngRoute(
            path: Routes.toPath('${Routes.LOGIN}/:sourceRoute'),
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
        ),
        Routes.LOGIN: ngRoute(
            path: Routes.toPath('${Routes.LOGIN}/:sourceRoute/:id'),
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN)),
            preEnter: (RoutePreEnterEvent e) {
              if (e.parameters['id'] == 'null') {
                router.go('login_without_id', e.parameters);
              }
            }
        ),
        Routes.GAMES: ngRoute(
            path: Routes.toPath('${Routes.GAMES}/:id'),
            view: 'view/game.html',
            enter: (e) => sendGoogleAnalyticsPageView(e.path),
            preEnter: (RoutePreEnterEvent e) {
              print(e.parameters);
              if (e.parameters['id'] == 'null') {
                router.go('lobby', e.parameters);
              } else {
                e.allowEnter(checkLogin(Routes.GAMES, router.activePath, e.parameters));
              }
            }
        ),
        'lobby': ngRoute(
            path: Routes.toPath(Routes.GAMES),
            view: 'view/lobby.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAMES)),
            preEnter: (RoutePreEnterEvent e) => e.allowEnter(checkLogin(Routes.GAMES, router.activePath))
        ),
        Routes.LOGOUT: ngRoute(
            path: Routes.toPath('${Routes.LOGOUT}/:sourceRoute'),
            preEnter: (_) => logout()
        ),
        Routes.ROOT: ngRoute(
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView('/'),
            defaultRoute: true
        )
    });
  }
}
