library kick_event;

import 'game_event.dart';

class KickEvent extends GameEvent {
  static const String MSG_TYPE = "kickEvent";

  final int kickedPlayerId;
  final int kickedBy;

  KickEvent(gameId, this.kickedPlayerId, this.kickedBy) : super(MSG_TYPE, gameId) {
    if (kickedPlayerId == null) {
      throw new ArgumentError.notNull('kicked');
    }
    if (kickedBy == null) {
      throw new ArgumentError.notNull('kickedBy');
    }
  }

  factory KickEvent.fromJson(Map content) {
    return new KickEvent(content['gameId'], content['kicked'], content['kickedBy']);
  }

  void setContent() {
    super.setContent();

    content['kicked'] = kickedPlayerId;
    content['kickedBy'] = kickedBy;
  }
}
