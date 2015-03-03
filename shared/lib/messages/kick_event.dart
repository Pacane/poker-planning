library kick_event;

import 'game_event.dart';

class KickEvent extends GameEvent {
  static const String MSG_TYPE = "kickEvent";

  String kicked;
  String kickedBy;

  KickEvent(gameId, this.kicked, this.kickedBy) : super(MSG_TYPE, gameId) {
    if (kicked == null) {
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

    content['kicked'] = kicked;
    content['kickedBy'] = kickedBy;
  }
}
