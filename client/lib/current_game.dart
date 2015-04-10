library current_game;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_shared/game.dart';

@Injectable()
class CurrentGame {
  List<Tuple<String, String>> players = [];

  int _gameId;
  DateTime lastReset;

  void setGameId(String newGameId) {
    _gameId = int.parse(newGameId, onError: (_) => null);
  }

  int getGameId() {
    return _gameId;
  }

  DateTime getLastReset() {
    return lastReset;
  }

  void resetGameId() {
    _gameId = null;
  }

  void removeDisconnectedPlayers(Game game) {
    players.removeWhere((t) => !game.playerIsInGame(t.first));
  }

  void updateCards(Game game) {
    game.forEachPlayer((String player, String card) {
      updateCard(player, card);
    });
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
