library api_paths;

import 'package:poker_planning_client/config.dart';
import 'package:angular/angular.dart';

@Injectable()
class ApiPaths {
  AppConfig config;

  ApiPaths(this.config);

  String get basePath => "http://${config.hostname}:${config.restPort}";

  String game(int id) => "$basePath/games/$id";

  String authenticate(int id) => "${game(id)}/auth";
}