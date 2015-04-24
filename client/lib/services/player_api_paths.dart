import 'package:angular/angular.dart';

import 'package:poker_planning_client/services/api_paths.dart';

@Injectable()
class PlayerApiPaths {
  ApiPaths baseApiPaths;

  PlayerApiPaths(this.baseApiPaths);

  String players() => '${baseApiPaths.basePath}/players';

  String getPlayer(int playerId) => '${players()}/$playerId';

  String checkUser() => '${players()}/check';
}
