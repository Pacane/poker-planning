library game_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';

@Component(
    selector: 'game-component',
    cssUrl: 'packages/poker_planning_client/components/game_component.css',
    templateUrl: 'packages/poker_planning_client/components/game_component.html')
class GameComponent {
  CurrentUser currentUser;
  Router router;

  GameComponent(this.currentUser, this.router) {
    if (currentUser.userName == null) {
      router.go("login", {});
    }
  }
}
