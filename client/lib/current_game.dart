library current_game;

import 'package:angular/angular.dart';

@Injectable()
class CurrentGame {

  int _gameId;

  void setGameId(String newGameId) {
    _gameId = int.parse(newGameId, onError: (_) => null);
  }

  int getGameId() {
    return _gameId;
  }

  void resetGameId() {
    _gameId = null;
  }
}
