import 'package:test/test.dart';

import 'package:poker_planning_server/repository/game_repository.dart';
import 'package:poker_planning_server/repository/player_repository.dart';
import 'package:poker_planning_shared/game.dart';

String gameName = 'game name';
String password = 'some password';
bool revealed = false;
Map<int, String> players = {};
GameRepository gameRepository;
PlayerRepository playerRepository;

Game createGame() => new Game(gameName, revealed, players);

void main() {
  setUp(() {
    playerRepository = new PlayerRepository();
    gameRepository = new GameRepository(playerRepository);
  });

  test("repository should give a new game an id", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, password);

    expect(result.id, isNotNull);
  });

  test("repository should give different ids to created games", () {
    Game newGame = createGame();
    Game newGame2 = createGame();

    Game result = gameRepository.createGame(newGame, password);
    Game result2 = gameRepository.createGame(newGame2, password);

    expect(result.id, 1);
    expect(result2.id, 2);
  });

  test("creating a game should assign a reset date", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, password);

    expect(result.lastReset, isNotNull);
  });

  test("stores the password when creating the game", () {
    // TODO: Maybe check that the password is saved somewhere else?
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, password);

    expect(gameRepository.isPasswordValid(result.id, password), true);
    expect(gameRepository.isPasswordValid(result.id, "random things"), false);
  });

  test("returns true when password is valid", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, password);

    expect(gameRepository.isPasswordValid(result.id, password), true);
  });

  test("returns false when password is invalid", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, password);

    expect(gameRepository.isPasswordValid(result.id, "wrong password"), false);
  });

  test("returns true when password is null and game has no password", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, null);

    expect(gameRepository.isPasswordValid(result.id, null), true);
  });

  test("returns false when password is something and game has no password", () {
    Game newGame = createGame();

    Game result = gameRepository.createGame(newGame, null);

    expect(gameRepository.isPasswordValid(result.id, "wrong password"), false);
  });

  test("returns false when password is something and game doesn't exist", () {
    expect(gameRepository.isPasswordValid(1, "wrong password"), false);
  });
}
