library grocery_store_routing;

import 'package:angular/angular.dart';
import 'dart:js';

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

  void checkLogin(String sourceRoute, [Map parameters]) {
    currentUser.checkLogin(sourceRoute, parameters);
  }

  void logout() {
    print("LOGGING OUT ALMOST");
  }

  void sendGoogleAnalyticsPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
        Routes.ROOT: ngRoute(
            path: '/',
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView('/'),
            defaultRoute: true
        ),
        Routes.LOGIN: ngRoute(
            path: '${Routes.toPath(Routes.LOGIN)}/:sourceRoute/:id',
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
        ),
        Routes.GAME: ngRoute(
            path: '${Routes.toPath(Routes.GAMES)}/:id',
            view: 'view/game.html',
            enter: (_) {
              sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAME));
            },
            preEnter: (RoutePreEnterEvent e) {print(e.parameters); checkLogin(Routes.GAME, e.parameters);}
        ),
        Routes.GAMES: ngRoute(
            path: Routes.toPath(Routes.GAMES),
            view: 'view/lobby.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAMES)),
            preEnter: (RoutePreEnterEvent e) => checkLogin(Routes.GAMES, e.parameters)
        ),
        Routes.LOGOUT: ngRoute(
            path: Routes.toPath('${Routes.LOGOUT}/:sourceRoute'),
            preEnter: (_) => logout()
        )
    });
  }
}
