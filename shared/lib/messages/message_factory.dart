library message_factory;

import 'message.dart';
import 'kick_event.dart';
import 'login_event.dart';
import 'disconnect_event.dart';
import 'error.dart';
import 'card_selection_event.dart';
import 'reveal_request_event.dart';
import 'game_information.dart';
import 'reset_game_event.dart';
import 'game_has_reset_event.dart';

class MessageFactory {
  Message create(Map data) {
    String type = data['type'];
    Map content = data['content'];

    if (type != null && content != null) {
      return _create(type, content);
    }

    return null;
  }

  Message _create(String type, Map content) {
    switch (type) {
      case KickEvent.MSG_TYPE:
        return new KickEvent.fromJson(content);
      case ErrorEvent.MSG_TYPE:
        return new ErrorEvent.fromJson(content);
      case CardSelectionEvent.MSG_TYPE:
        return new CardSelectionEvent.fromJson(content);
      case LoginEvent.MSG_TYPE:
        return new LoginEvent.fromJson(content);
      case DisconnectEvent.MSG_TYPE:
        return new DisconnectEvent.fromJson(content);
      case RevealRequestEvent.MSG_TYPE:
        return new RevealRequestEvent.fromJson(content);
      case GameInformation.MSG_TYPE:
        return new GameInformation.fromJson(content);
      case ResetGameEvent.MSG_TYPE:
        return new ResetGameEvent.fromJson(content);
      case GameHasResetEvent.MSG_TYPE:
        return new GameHasResetEvent.fromJson(content);
      default:
        return null;
    }
  }
}
