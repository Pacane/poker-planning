library grocery_store_routing;

import 'package:angular/angular.dart';
import 'dart:js';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

import 'package:poker_planning_client/routes.dart';

@Injectable()
class AppRouter implements Function {
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope scope;

  AppRouter(this.socketCommunication, this.currentUser, this.scope);

  void checkLogin(String sourceRoute) {
    currentUser.checkLogin(sourceRoute);
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
            preEnter: (_) => checkLogin(Routes.GAMES),
            leave: (_) => socketCommunication.sendSocketMsg({"disconnect":currentUser.userName})
        ),
        Routes.GAME: ngRoute(
            path: Routes.toPath(Routes.GAME),
            view: 'view/game.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAME)),
            preEnter: (_) => checkLogin(Routes.GAME),
            leave: (_) => socketCommunication.sendSocketMsg({"disconnect":currentUser.userName})
        ),
        Routes.LOGIN: ngRoute(
            path: Routes.toPath('${Routes.LOGIN}/:sourceRoute'),
            view: 'view/login.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.LOGIN))
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
