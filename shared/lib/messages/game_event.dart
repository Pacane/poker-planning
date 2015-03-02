import 'message.dart';

abstract class GameEvent extends Message {
  int gameId;

  GameEvent(type, this.gameId) : super(type) {
    if (gameId == null) {
      throw new ArgumentError.notNull('gameId');
    }
  }

  void setContent() {
    content['gameId'] = gameId;
  }
}
