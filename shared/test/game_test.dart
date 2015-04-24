import 'package:test/test.dart';
import 'package:poker_planning_shared/player.dart';
import 'package:poker_planning_shared/game.dart';

import 'dart:convert' show JSON;

void main() {
  test("add player should add the player", () {
    Player player1 = new Player()
      ..displayName = "Roger"
      ..id = 1;
    Player player2 = new Player()
      ..displayName = "Rafael"
      ..id = 2;

    Game game = new Game("test game", true, {});
    game.addPlayer(player1.id);
    game.addPlayer(player2.id);

    game.setCard(player1.id, "8");
    game.setCard(player2.id, "5");

    String encoded = JSON.encode(game);
    print(encoded);
    Map decoded = JSON.decode(encoded);

    print(decoded);
  });

  test("json decode", () {
    String json =
        '{"id": 1, "name":"test game","revealed":true,"players":{"1":"8","2":"5"},"lastReset":"","isProtected":false}';

    Game game = new Game.fromJson(json);
    expect(game.id, 1);
  });
}
