import 'message.dart';
import 'kick_event.dart';
import 'error.dart';

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
      default:
        return null;
    }
  }
}
