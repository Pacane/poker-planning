library initiate_kick_event;

import 'game_event.dart';

class InitiateKickEvent extends GameEvent {
  static const String MSG_TYPE = "initiateKickEvent";

  final int kickedPlayerId;
  final int kickedBy;

  InitiateKickEvent(gameId, this.kickedPlayerId, this.kickedBy) : super(MSG_TYPE, gameId) {
    if (kickedPlayerId == null) {
      throw new ArgumentError.notNull('kicked');
    }
    if (kickedBy == null) {
      throw new ArgumentError.notNull('kickedBy');
    }
  }

  factory InitiateKickEvent.fromJson(Map content) {
    return new InitiateKickEvent(content['gameId'], content['kicked'], content['kickedBy']);
  }

  void setContent() {
    super.setContent();

    content['kicked'] = kickedPlayerId;
    content['kickedBy'] = kickedBy;
  }
}
