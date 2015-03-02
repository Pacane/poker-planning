import 'message_handler.dart';
import '../message.dart';
import '../message_factory.dart';

class MessageHandlers {
  MessageFactory messageFactory;

  List<MessageHandler> _handlers;

  MessageHandlers(this.messageFactory, this._handlers);

  void handleMessage(Map json) {
    Message message = messageFactory.create(json);
    if (message != null) {
      for (MessageHandler handler in _handlers) {
        handler.handleMessage(message);
      }
    }
  }
}
