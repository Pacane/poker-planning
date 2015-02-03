library poker_planning_config;

import 'package:angular/angular.dart';

@Injectable()
class Config {
  Map config = {};
  String hostname;
  int port;
  int restPort;

  void initConfig() {
    hostname = config['hostname'];
    port = config['port'];
    restPort = config['restPort'];
  }
}