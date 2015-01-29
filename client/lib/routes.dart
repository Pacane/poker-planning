library routes;

class Routes {
  /*  I'm using '_' to define sub routes, because when I use '/' as in '/games/new',
      the router interprets it as '/games' and then '/new' to use a subview
      (which is not what I want to do here...) */
  static const String NEW = 'new';
  static const String GAMES = 'games';
  static const String NEW_GAME = 'games_new';

  static const String GAME = 'game';
  static const String LOGIN = 'login';
  static const String ROOT = 'root';

  static String toPath(String routeName) => '/'+ routeName.replaceAll('_', '/');
}
