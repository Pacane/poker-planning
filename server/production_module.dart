library production_module;

import 'package:di/di.dart';

import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/resources/time.dart';
import 'package:poker_planning_server/resources/interceptors.dart';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/broadcaster.dart';

import 'package:poker_planning_shared/messages/message_factory.dart';

Module _restModule;
Module _productionModule;

Module getRestModule() {
  if (_restModule == null) {
    _restModule = new Module()
      ..bind(Games)
      ..bind(Time)
      ..bind(Interceptors);
  }
  return _restModule;
}

Module getProductionModule() {
  if (_productionModule == null) {
    _productionModule = new Module()
      ..bind(GameRepository, toValue: new GameRepository())
      ..bind(MessageFactory)
      ..bind(Broadcaster);
  }
  return _productionModule;
}
