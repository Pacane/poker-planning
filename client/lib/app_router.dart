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
    scope.broadcast("check-login", [sourceRoute]);
  }

  void sendGoogleAnalyticsPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
        Routes.GAME: ngRoute(
            path: Routes.toPath(Routes.GAME),
            view: 'view/game.html',
            enter: (_) => new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.GAME)]),
            preEnter: (_) => checkLogin(Routes.GAME),
            leave: (_) => socketCommunication.sendSocketMsg({"disconnect":currentUser.userName})
        ),
        Routes.GAMES: ngRoute(
            path: Routes.toPath(Routes.GAMES),
            view: 'view/games.html',
            enter: (_) => new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.GAME)]),
            preEnter: (_) => checkLogin(Routes.GAMES),
            leave: (_) => socketCommunication.sendSocketMsg({"disconnect":currentUser.userName})
        ),
        Routes.NEW_GAME: ngRoute(
            path: Routes.toPath(Routes.NEW_GAME),
            viewHtml: '<create-game-component></create-game-component>',
            enter: (_) => new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.NEW_GAME)]),
            preEnter: (_) => checkLogin(Routes.NEW_GAME)
        ),
        Routes.LOGIN: ngRoute(
            path: Routes.toPath(Routes.LOGIN),
            view: 'view/login.html',
            enter: (_) => new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.LOGIN)])
        ),
        Routes.ROOT: ngRoute(
            path: '/',
            view: 'view/home.html',
            enter: (_) => new JsObject(context['ga'], ['send', 'pageview', '/']),
            defaultRoute: true
        ),
    });
  }
}
