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

  call(Router router, RouteViewFactory views) {
    views.configure({
        Routes.GAME: ngRoute(
            path: Routes.toPath(Routes.GAME),
            view: 'view/game.html',
            enter: (_) {
              new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.GAME)]);
              scope.broadcast("check-login", {
              });
            },
            leave: (_) {
              socketCommunication.sendSocketMsg(
                  {
                      "disconnect":currentUser.userName
                  }
              );
            }
        ),
        Routes.LOGIN: ngRoute(
            path: Routes.toPath(Routes.LOGIN),
            view: 'view/login.html',
            enter: (_) {
              new JsObject(context['ga'], ['send', 'pageview', Routes.toPath(Routes.LOGIN)]);
            }),
        Routes.ROOT: ngRoute(
            path: '/',
            view: 'view/home.html',
            enter: (_) {
              new JsObject(context['ga'], ['send', 'pageview', '/']);
            },
            defaultRoute: true),
    });
  }
}
