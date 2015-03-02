import 'message.dart';

class GameEvent extends Message {
  String event;
  int gameId;

  GameEvent(this.event, this.gameId, Map content) : super('gameEvent', content) {
    if (event == null) {
      throw new ArgumentError.notNull('event');
    }
    if (gameId == null) {
      throw new ArgumentError.notNull('gameId');
    }
  }

  Map toJson() {
    Map json = super.toJson();
    json['event'] = event;
    json['gameId'] = gameId;

    return json;
  }
}