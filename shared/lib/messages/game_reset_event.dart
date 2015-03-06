library game_reset_event;

import 'game_event.dart';

class GameResetEvent extends GameEvent {
  static const String MSG_TYPE = "gameResetEvent";

  GameResetEvent(gameId) : super(MSG_TYPE, gameId);

  factory GameResetEvent.fromJson(Map content) {
    return new GameResetEvent(content['gameId']);
  }

  void setContent() {
    super.setContent();
  }
}
