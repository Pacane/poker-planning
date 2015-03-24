library game_reset_event;

import 'game_event.dart';

class ResetGameEvent extends GameEvent {
  static const String MSG_TYPE = "resetGameEvent";

  ResetGameEvent(gameId) : super(MSG_TYPE, gameId);

  factory ResetGameEvent.fromJson(Map content) {
    return new ResetGameEvent(content['gameId']);
  }
}
