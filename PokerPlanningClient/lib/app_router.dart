library grocery_store_routing;

import 'package:angular/angular.dart';

void routeInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'game': ngRoute(
          path: '/game',
          view: 'view/game.html'),
      'login': ngRoute(
          path: '/login',
          view: 'view/login.html'),
      'root': ngRoute(
          path: '/',
          view: 'view/login.html',
          defaultRoute: true),
  });
}
