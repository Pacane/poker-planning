import 'package:test/test.dart';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_shared/game.dart';

String gameName = 'game name';
String password = 'some password';
bool revealed = false;
Map<String, String> players = {};
GameRepository repository;

Game createGame() => new Game(gameName, revealed, players);

void main() {
  setUp(() {
    repository = new GameRepository();
  });

  test("repository should give a new game an id", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, password);

    expect(result.id, isNotNull);
  });

  test("repository should give different ids to created games", () {
    Game newGame = createGame();
    Game newGame2 = createGame();

    Game result = repository.createGame(newGame, password);
    Game result2 = repository.createGame(newGame2, password);

    expect(result.id, 1);
    expect(result2.id, 2);
  });

  test("creating a game should assign a reset date", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, password);

    expect(result.lastReset, isNotNull);
  });

  test("stores the password when creating the game", () {
    // TODO: Maybe check that the password is saved somewhere else?
    Game newGame = createGame();

    Game result = repository.createGame(newGame, password);

    expect(repository.isPasswordValid(result.id, password), true);
    expect(repository.isPasswordValid(result.id, "random things"), false);
  });

  test("returns true when password is valid", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, password);

    expect(repository.isPasswordValid(result.id, password), true);
  });

  test("returns false when password is invalid", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, password);

    expect(repository.isPasswordValid(result.id, "wrong password"), false);
  });

  test("returns true when password is null and game has no password", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, null);

    expect(repository.isPasswordValid(result.id, null), true);
  });

  test("returns false when password is something and game has no password", () {
    Game newGame = createGame();

    Game result = repository.createGame(newGame, null);

    expect(repository.isPasswordValid(result.id, "wrong password"), false);
  });

  test("returns false when password is something and game doesn't exist", () {
    expect(repository.isPasswordValid(1, "wrong password"), false);
  });
}
