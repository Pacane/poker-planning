library grocery_store_routing;

import 'package:angular/angular.dart';
import 'dart:js';

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

  AppRouter(this.socketCommunication, this.currentUser, this.scope, this.currentGame);

  void checkLogin(String sourceRoute) {
    currentUser.checkLogin(sourceRoute);
  }

  void logout() {
    logger.info("LOGGING OUT ALMOST");
  }

  void sendGoogleAnalyticsPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
        Routes.NEW_GAME: ngRoute(
            path: Routes.toPath(Routes.NEW_GAME),
            view: 'view/new_game.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.NEW_GAME)),
            preEnter: (_) => checkLogin(Routes.NEW_GAME)
        ),
        Routes.GAMES: ngRoute(
            path: Routes.toPath(Routes.GAMES),
            view: 'view/games.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAMES)),
            preEnter: (_) => checkLogin(Routes.GAMES)
        ),
        Routes.GAME: ngRoute(
            path: '${Routes.toPath(Routes.GAMES)}/:id',
            view: 'view/game.html',
            enter: (_) {
              sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAME));
            },
            preEnter: (_) => checkLogin('${Routes.GAME}/:id')
        ),
        Routes.LOGIN: ngRoute(
            path: Routes.toPath('${Routes.LOGIN}/:sourceRoute'),
            view: 'view/login.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
        ),
        'login_without_route': ngRoute(
            path: Routes.toPath(Routes.LOGIN),
            view: 'view/login.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
        ),
        Routes.LOGOUT: ngRoute(
            path: Routes.toPath('${Routes.LOGOUT}/:sourceRoute'),
            preEnter: (_) => logout()
        ),
        Routes.ROOT: ngRoute(
            path: '/',
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView('/'),
            defaultRoute: true
        ),
    });
  }
}
