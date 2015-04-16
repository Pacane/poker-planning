library time_api_paths;

import 'package:poker_planning_client/services/api_paths.dart';
import 'package:angular/angular.dart';

@Injectable()
class TimeApiPaths {
  ApiPaths basePaths;

  TimeApiPaths(this.basePaths);

  String getServerTime() => "${basePaths.basePath}/time";
}
