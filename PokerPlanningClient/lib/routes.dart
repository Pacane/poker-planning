library routes;

class Routes {
  static String get GAME => 'game';
  static String get LOGIN => 'login';
  static String get ROOT => 'root';

  static String toPath(String routeName) => '/'+ routeName;
}
