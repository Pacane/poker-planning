import 'message_handler.dart';
import '../message.dart';
import '../message_factory.dart';

class MessageHandlers {
  MessageFactory messageFactory;

  List<MessageHandler> _handlers;

  MessageHandlers(this.messageFactory, this._handlers);

  void handleMessage(Map json) {
    String type = json['type'];
    Map content = json['content'];

    if (type != null && content != null) {
      Message message = messageFactory.create(type, content);
      for (MessageHandler handler in _handlers) {
        handler.handleMessage(message);
      }
    }
  }
}
