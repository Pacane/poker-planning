library current_game;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';

@Injectable()
class CurrentGame {
  List<Tuple<String, String>> players = [];

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

  void updateCard(String player, String card) {
    if (!players.any((x) => x.first == player)) {
      players.add(new Tuple(player, card));
    } else {
      players.forEach((t) {
        if (t.first == player) {
          t.second = card;
          return;
        }
      });
    }
  }
}
