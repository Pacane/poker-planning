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

  void checkLogin(String sourceRoute) {
    currentUser.checkLogin(sourceRoute);
  }

  void logout() {
    print("LOGGING OUT ALMOST");
  }

  void sendGoogleAnalyticsPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  call(Router router, RouteViewFactory views) {
    views.configure({
        Routes.GAMES: ngRoute(
            path: Routes.toPath(Routes.GAMES),
            view: 'view/lobby.html',
            enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAMES)),
            preEnter: (RoutePreEnterEvent e) => checkLogin(Routes.GAMES + e.path),
            mount : {
                Routes.GAME: ngRoute(
                    path: '${Routes.toPath(Routes.GAMES)}/:id',
                    view: 'view/game.html',
                    enter: (_) => sendGoogleAnalyticsPageView(Routes.toPath(Routes.GAME))
                )
            }
        ),
        Routes.LOGOUT: ngRoute(
            path: Routes.toPath('${Routes.LOGOUT}/:sourceRoute'),
            preEnter: (_) => logout()
        ),
        Routes.ROOT: ngRoute(
            path: '${Routes.toPath(Routes.LOGIN)}/:sourceRoute',
            view: 'view/home.html',
            enter: (_) => sendGoogleAnalyticsPageView('/'),
            defaultRoute: true
        ),
    });
  }
}
