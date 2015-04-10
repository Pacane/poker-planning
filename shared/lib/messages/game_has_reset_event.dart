library game_has_reset_event;

import 'message.dart';

class GameHasResetEvent extends Message {
  static const String MSG_TYPE = "gameHasResetEvent";

  DateTime lastReset;

  GameHasResetEvent(this.lastReset) : super(MSG_TYPE);

  void setContent() {
    content['lastReset'] = lastReset.toIso8601String();
  }

  factory GameHasResetEvent.fromJson(Map content) {
    return new GameHasResetEvent(DateTime.parse(content['lastReset']));
  }
}
