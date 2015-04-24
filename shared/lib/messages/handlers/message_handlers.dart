library message_handlers;

import 'dart:async';
import 'message_handler.dart';
import '../message.dart';
import '../message_factory.dart';

class MessageHandlers {
  MessageFactory messageFactory;

  List<MessageHandler> _handlers;

  MessageHandlers(this.messageFactory, this._handlers);

  Future handleMessage(Map json) async {
    Message message = messageFactory.create(json);
    if (message != null) {
      _handlers.forEach((MessageHandler handler) async => await handler.tryHandlingMessage(message));
    }
  }
}
