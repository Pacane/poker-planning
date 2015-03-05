library login_event;

import 'game_event.dart';

class LoginEvent extends GameEvent {
  static const String MSG_TYPE = "loginEvent";

  final String username;

  LoginEvent(gameId, this.username) : super(MSG_TYPE, gameId) {
    if (username == null) {
      throw new ArgumentError.notNull('username');
    }
  }

  factory LoginEvent.fromJson(Map content) {
    return new LoginEvent(content['gameId'], content['username']);
  }

  void setContent() {
    super.setContent();

    content['username'] = username;
  }
}
