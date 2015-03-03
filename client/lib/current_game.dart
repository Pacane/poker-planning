library current_game;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';

@Injectable()
class CurrentGame {
  List<Tuple<String, String>> players = [];

  int _gameId;

  void setGameId(String newGameId) {
    _gameId = int.parse(newGameId);
  }

  int getGameId() {
    return _gameId;
  }

  void resetGameId() {
    _gameId = null;
  }
}
