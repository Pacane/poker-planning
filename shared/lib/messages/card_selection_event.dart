library card_selection_event;

import 'game_event.dart';

class CardSelectionEvent extends GameEvent {
  static const String MSG_TYPE = "cardSelectionEvent";

  final String playerName;
  final String selectedCard;

  CardSelectionEvent(gameId, this.playerName, this.selectedCard) : super(MSG_TYPE, gameId) {
    if (playerName == null) {
      throw new ArgumentError.notNull('playerName');
    }
    if (selectedCard == null) {
      throw new ArgumentError.notNull('selectedCard');
    }
  }

  factory CardSelectionEvent.fromJson(Map content) {
    return new CardSelectionEvent(content['gameId'], content['playerName'], content['selectedCard']);
  }

  void setContent() {
    super.setContent();

    content['playerName'] = playerName;
    content['selectedCard'] = selectedCard;
  }
}
