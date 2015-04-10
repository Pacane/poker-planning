library poker_planning_config;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

import 'package:poker_planning_shared/loglevel_parser.dart';

@Injectable()
class AppConfig {
  Map config = {};
  String hostname;
  int port;
  int restPort;

  void initConfig() {
    hostname = config['hostname'];
    port = config['port'];
    restPort = config['restPort'];

    Logger.root.level = LogLevelParser.logLevel(config['logLevel']);
  }
}
