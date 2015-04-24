library player_kicked_event;

import 'game_event.dart';
import 'package:poker_planning_shared/player.dart';

class PlayerKickedEvent extends GameEvent {
  static const String MSG_TYPE = "playerKickedEvent";

  final Player kickedPlayer;
  final Player kickedBy;

  PlayerKickedEvent(gameId, this.kickedPlayer, this.kickedBy) : super(MSG_TYPE, gameId) {
    if (kickedPlayer == null) {
      throw new ArgumentError.notNull('kickedPlayer');
    }
    if (kickedBy == null) {
      throw new ArgumentError.notNull('kickedBy');
    }
  }

  factory PlayerKickedEvent.fromJson(Map content) {
    return new PlayerKickedEvent(
        content['gameId'], new Player.fromMap(content['kickedPlayer']), new Player.fromMap(content['kickedBy']));
  }

  void setContent() {
    super.setContent();

    content['kickedPlayer'] = kickedPlayer;
    content['kickedBy'] = kickedBy;
  }
}
