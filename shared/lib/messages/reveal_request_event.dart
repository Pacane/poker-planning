library reveal_request_event;

import 'game_event.dart';

class RevealRequestEvent extends GameEvent {
  static const String MSG_TYPE = "revealRequestEvent";

  RevealRequestEvent(gameId) : super(MSG_TYPE, gameId) {
  }

  factory RevealRequestEvent.fromJson(Map content) {
    return new RevealRequestEvent(content['gameId']);
  }

  void setContent() {
    super.setContent();
  }
}
