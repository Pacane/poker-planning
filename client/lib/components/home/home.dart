library home_component;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:poker_planning_client/current_user.dart';

@Component(
    selector: 'home',
    cssUrl: 'packages/poker_planning_client/css/layout.css',
    templateUrl: 'packages/poker_planning_client/components/home/home.html')
class HomeComponent implements AttachAware {
  CurrentUser currentUser;

  HomeComponent(this.currentUser);

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
