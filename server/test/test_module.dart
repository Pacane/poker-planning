library test_module;

import 'package:di/di.dart';

import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/resources/time.dart';
import 'package:poker_planning_server/resources/interceptors.dart';

import 'package:poker_planning_server/repository/game_repository.dart';

Module getRestModule() {
  return new Module()
    ..bind(Games)
    ..bind(Time)
    ..bind(Interceptors);
}

Module getSharedModule(Injector injector) {
  return new Module()..bind(GameRepository, toValue: injector.get(GameRepository));
}
