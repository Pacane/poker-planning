library current_game;

import 'package:angular/angular.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/player.dart';

@Injectable()
class CurrentGame {
  List<Tuple<Player, String>> players = [];

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
    players.removeWhere((Tuple t) => !game.isPlayerInTheGame(t.first.id));
  }

  void updateCards(Game game, List<Player> players) {
    game.forEachPlayer((int playerId, String card) {
      updateCard(players.singleWhere((player) => player.id == playerId), card);
    });
  }

  void updateCard(Player player, String card) {
    if (!isPlayerInTheGame(player)) {
      players.add(new Tuple(player, card));
    } else {
      updateCardValue(player, card);
    }
  }

  bool isPlayerInTheGame(Player player) => players.any((Tuple t) => t.first == player);

  void updateCardValue(Player player, String card) {
    players.firstWhere((Tuple<Player, String> t) => t.first == player).second = card;
  }
}
