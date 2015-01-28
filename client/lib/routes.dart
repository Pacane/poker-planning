library routes;

class Routes {
  static const String NEW = 'new';
  static const String GAMES = 'games';
  static const String NEW_GAME = "$GAMES/$NEW";

  static const String GAME = 'game';
  static const String LOGIN = 'login';
  static const String ROOT = 'root';

  static String toPath(String routeName) => '/'+ routeName;
}
