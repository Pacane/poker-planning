import 'dart:html';
import 'package:angular/angular.dart';

@Injectable()
class CurrentUser {
  void logOffCurrentUser() {
    localStorage.remove('username');
  }

  Storage localStorage = window.localStorage;

  String get userName => localStorage['username'];
  void set userName(String userName) {
    localStorage['username'] = userName;
  }
}
