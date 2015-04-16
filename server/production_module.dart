library production_module;

import 'package:di/di.dart';

import 'package:poker_planning_server/resources/games.dart';
import 'package:poker_planning_server/resources/players.dart';
import 'package:poker_planning_server/resources/time.dart';
import 'package:poker_planning_server/resources/interceptors.dart';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/repository/player_repository.dart';
import 'package:poker_planning_server/broadcaster.dart';

import 'package:poker_planning_shared/messages/message_factory.dart';

Module _restModule;
Module _socketModule;
Module _sharedModule;

Module getRestModule() {
  if (_restModule == null) {
    _restModule = new Module()
      ..bind(Games)
      ..bind(Players)
      ..bind(Time)
      ..bind(Interceptors);
  }
  return _restModule;
}

Module getSocketModule() {
  if (_socketModule == null) {
    _socketModule = new Module()
      ..bind(GameRepository)
      ..bind(PlayerRepository)
      ..bind(MessageFactory)
      ..bind(Broadcaster);
  }
  return _socketModule;
}

Module getSharedModule(Injector injector) {
  if (_sharedModule == null) {
    _sharedModule = new Module()
      ..bind(GameRepository, toValue: injector.get(GameRepository))
      ..bind(PlayerRepository, toValue: injector.get(PlayerRepository));
  }
  return _sharedModule;
}
