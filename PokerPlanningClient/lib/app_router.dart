library grocery_store_routing;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/socket_communication.dart';

@Injectable()
class AppRouter implements Function {
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope scope;

  AppRouter(this.socketCommunication, this.currentUser, this.scope);

  call(Router router, RouteViewFactory views) {
    views.configure({
        'game': ngRoute(
            path: '/game',
            view: 'view/game.html',
            enter: (_) => scope.broadcast("check-login", {
            }),
            leave: (_) {
              socketCommunication.sendSocketMsg(
                  {
                      "disconnect":currentUser.userName
                  }
              );
            }
        ),
        'login': ngRoute(
            path: '/login',
            view: 'view/login.html'),
        'root': ngRoute(
            path: '/',
            view: 'view/login.html',
            defaultRoute: true),
    });
  }
}
