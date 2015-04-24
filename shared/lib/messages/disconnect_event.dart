library disconnect_event;

import 'game_event.dart';

class DisconnectEvent extends GameEvent {
  static const String MSG_TYPE = "disconnectEvent";

  final int userId;

  DisconnectEvent(gameId, this.userId) : super(MSG_TYPE, gameId) {
    if (userId == null) {
      throw new ArgumentError.notNull('userId');
    }
  }

  factory DisconnectEvent.fromJson(Map content) {
    return new DisconnectEvent(content['gameId'], content['userId']);
  }

  void setContent() {
    super.setContent();

    content['userId'] = userId;
  }
}
