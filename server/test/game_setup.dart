import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/resources/games.dart';

import 'package:di/di.dart';

import 'package:redstone/server.dart' as app;

GameRepository gameRepository;
Games gameResource;

setupGameResource() async {
  gameRepository = new GameRepository();

  app.addModule(new Module()
    ..bind(Games)
    ..bind(GameRepository, toValue: gameRepository));

  app.setUp([#games_resource]);
}

tearDownGame() {
  app.tearDown();
}
