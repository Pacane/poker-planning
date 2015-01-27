library home_component;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/routes.dart';

@Component(
    selector: 'home-component',
    cssUrl: 'packages/poker_planning_client/components/core.css',
    templateUrl: 'packages/poker_planning_client/components/home_component.html')
class HomeComponent {
  Router router;

  HomeComponent(this.router);

  start() => router.go(Routes.LOGIN, {});
}
