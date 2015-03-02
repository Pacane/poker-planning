import 'message.dart';
import 'kick_event.dart';
import 'error.dart';

class MessageFactory {
  Message create(String type, Map content) {
    switch (type) {
      case KickEvent.MSG_TYPE:
        return new KickEvent.fromJson(content);
      case ErrorEvent.MSG_TYPE:
        return new ErrorEvent.fromJson(content);
      default:
        return null;
    }
  }
}
