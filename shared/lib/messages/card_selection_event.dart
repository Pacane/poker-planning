library card_selection_event;

import 'game_event.dart';

class CardSelectionEvent extends GameEvent {
  static const String MSG_TYPE = "cardSelectionEvent";

  final int playerId;
  final String selectedCard;

  CardSelectionEvent(gameId, this.playerId, this.selectedCard) : super(MSG_TYPE, gameId) {
    if (playerId == null) {
      throw new ArgumentError.notNull('playerId');
    }
    if (selectedCard == null) {
      throw new ArgumentError.notNull('selectedCard');
    }
  }

  factory CardSelectionEvent.fromJson(Map content) {
    return new CardSelectionEvent(content['gameId'], content['playerId'], content['selectedCard']);
  }

  void setContent() {
    super.setContent();

    content['playerId'] = playerId;
    content['selectedCard'] = selectedCard;
  }
}
