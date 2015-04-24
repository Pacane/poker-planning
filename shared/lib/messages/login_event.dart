library login_event;

import 'game_event.dart';

class LoginEvent extends GameEvent {
  static const String MSG_TYPE = "loginEvent";

  final int userId;

  LoginEvent(gameId, this.userId) : super(MSG_TYPE, gameId) {
    if (userId == null) {
      throw new ArgumentError.notNull('userId');
    }
  }

  factory LoginEvent.fromJson(Map content) {
    return new LoginEvent(content['gameId'], content['userId']);
  }

  void setContent() {
    super.setContent();

    content['userId'] = userId;
  }
}
