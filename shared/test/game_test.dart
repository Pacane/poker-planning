import 'package:test/test.dart';
import 'package:poker_planning_shared/player.dart';
import 'package:poker_planning_shared/game.dart';

void main() {
  test("add player should add the player", () {
    Player player1 = new Player()
      ..displayName = "Roger"
      ..id = 1;
    Player player2 = new Player()
      ..displayName = "Rafael"
      ..id = 2;

    Game game = new Game("test game", true, {});
  });
}
