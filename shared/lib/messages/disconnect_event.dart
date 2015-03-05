library disconnect_event;

import 'game_event.dart';

class DisconnectEvent extends GameEvent {
  static const String MSG_TYPE = "disconnectEvent";

  final String username;

  DisconnectEvent(gameId, this.username) : super(MSG_TYPE, gameId) {
    if (username == null) {
      throw new ArgumentError.notNull('username');
    }
  }

  factory DisconnectEvent.fromJson(Map content) {
    return new DisconnectEvent(content['gameId'], content['username']);
  }

  void setContent() {
    super.setContent();

    content['username'] = username;
  }
}
