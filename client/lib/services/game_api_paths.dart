library game_api_paths;

import 'package:poker_planning_client/services/api_paths.dart';
import 'package:angular/angular.dart';

@Injectable()
class GameApiPaths {
  ApiPaths basePaths;

  GameApiPaths(this.basePaths);

  String game(int id) => "${basePaths.basePath}/games/$id";

  String authenticate(int gameId) => "${game(gameId)}/auth";

  String getPlayers(int gameId) => "${game(gameId)}/players";
}
