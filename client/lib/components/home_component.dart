library home_component;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/routes.dart';
import 'package:poker_planning_client/current_user.dart';

@Component(
    selector: 'home-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/home_component.html')
class HomeComponent implements AttachAware {
  Router router;
  CurrentUser currentUser;

  HomeComponent(this.router, this.currentUser);

  start() => router.go(Routes.GAMES, {});

  void attach() {
    /* TODO: Find a better way to manage the "logged in as XXX" for the cases of
    - New user
    - Existing user coming back
    - Existing user logging off
    - etc?
    */

    if (currentUser.userName != null) {
      currentUser.showLoginSuccessful();
    } else {
      currentUser.hideLoginStatus();
    }
  }

}
