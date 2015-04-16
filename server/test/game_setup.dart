import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/repository/player_repository.dart';
import 'package:poker_planning_server/resources/games.dart';
import 'test_module.dart';

import 'package:di/di.dart';

import 'package:redstone/server.dart' as app;

GameRepository gameRepository;
Games gameResource;
ModuleInjector injector;

setupGameResource() async {
  injector = new ModuleInjector([
    new Module()
      ..bind(GameRepository)
      ..bind(PlayerRepository)
  ]);
  gameRepository = injector.get(GameRepository);

  app.addModule(getRestModule());
  app.addModule(getSharedModule(injector));

  app.setUp([#games_resource]);
}

tearDownGame() {
  app.tearDown();
}
