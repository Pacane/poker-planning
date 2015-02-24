library loglevel_parser;

import "package:logging/logging.dart";

class LogLevelParser {
  static Level logLevel(String level) {
    switch (level) {
      case 'ALL':
        return Level.ALL;
      case 'OFF':
        return Level.OFF;
      case 'FINEST':
        return Level.FINEST;
      case 'FINER':
        return Level.FINER;
      case 'FINE':
        return Level.FINE;
      case 'CONFIG':
        return Level.CONFIG;
      case 'INFO':
        return Level.INFO;
      case 'WARNING':
        return Level.WARNING;
      case 'SEVERE':
        return Level.SEVERE;
      case 'SHOUT':
        return Level.SHOUT;
      default:
        return Level.INFO;
    }
  }
}
