import 'dart:convert' show JSON;
import 'dart:async';

import 'package:test/test.dart';
import 'game_setup.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';

String gameName = 'dummy-game-name';
String gamePassword = '12345abcde';

void main() {
  setUp(() {
    setupGameResource();
  });

  tearDown(() {
    tearDownGame();
  });

  test("should add the game to the repository when creating it", () async {
    expect(gameRepository.games.length, 0);

    await createGame(gameName, gamePassword);

    expect(gameRepository.games.length, 1);
    expect(gameRepository.games[1].name, gameName);
  });

  test("should return true if the password is valid", () async {
    await createGame(gameName, gamePassword);

    expect(gameRepository.isPasswordValid(1, gamePassword), true);
  });

  test("should return false if the password is invalid", () async {
    await createGame(gameName, gamePassword);

    expect(gameRepository.isPasswordValid(1, 'another password'), false);
  });
}

Future<MockHttpResponse> createGame(String name, String password) async {
  MockRequest req = new MockRequest("/games",
      method: app.POST,
      body: JSON.encode({"name": name, "password": password}),
      headers: {"Content-type": "application/json"});

  MockHttpResponse resp = await app.dispatch(req);

  expect(resp.statusCode, 200);

  return resp;
}
