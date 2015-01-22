library routes;

class Routes {
  static const String GAME = 'game';
  static const String LOGIN = 'login';
  static const String ROOT = 'root';

  static String toPath(String routeName) => '/'+ routeName;
}
