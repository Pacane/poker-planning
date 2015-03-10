library game_information;

import 'dart:convert';

import 'game_event.dart';
import '../game.dart';

class GameInformation extends GameEvent {
  static const String MSG_TYPE = "gameInformation";

  final bool revealed;
  final Game game;

  GameInformation(gameId, this.revealed, this.game) : super(MSG_TYPE, gameId) {
    if (revealed == null) {
      throw new ArgumentError.notNull('revealed');
    }
    if (game == null) {
      throw new ArgumentError.notNull('game');
    }
  }

  factory GameInformation.fromJson(Map content) {
    return new GameInformation(content['gameId'], content['revealed'], new Game.fromMap(content['game']));
  }

  void setContent() {
    super.setContent();

    if (!revealed) {
      Game gameCopy = new Game.fromMap(JSON.decode(JSON.encode(game)));
      gameCopy.obfuscateSelectedCards();
      content['game'] = gameCopy;
    } else {
      content['game'] = game;
    }

    content['revealed'] = revealed;
  }
}
