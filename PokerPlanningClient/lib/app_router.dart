library grocery_store_routing;

import 'package:angular/angular.dart';

void routeInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'game': ngRoute(
          path: '/game',
          view: 'view/game.html'),
      'root': ngRoute(
          path: '/'),
  });
}
