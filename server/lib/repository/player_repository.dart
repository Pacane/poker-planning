import 'package:poker_planning_shared/player.dart';

class PlayerRepository {
  List<Player> _players = [];

  PlayerRepository() {
    _idSeed = 1;
  }

  Player createPlayer(String displayName) {
    Player newPlayer = new Player()
      ..id = getNewId
      ..displayName = displayName;

    _players.add(newPlayer);

    return newPlayer;
  }

  Player getPlayer(int playerId) {
    return _players.firstWhere((player) => player.id == playerId, orElse: () => null);
  }

  Iterable<Player> getPlayers(Iterable<int> playerIds) {
    return playerIds.map((int id) => _players.singleWhere((player) => player.id == id));
  }

  void removePlayer(int playerId) {
    _players.removeWhere((player) => player.id == playerId);
  }

  int _idSeed;
  int get getNewId => _idSeed++;

  bool playerExists(Player player) => _players.contains(player);
}
