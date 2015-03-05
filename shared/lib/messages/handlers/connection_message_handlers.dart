library connection_message_handlers;

import 'connection_message_handler.dart';
import '../message.dart';
import '../message_factory.dart';

import 'dart:io';

class ConnectionMessageHandlers {
  MessageFactory messageFactory;

  List<ConnectionMessageHandler> _handlers;

  ConnectionMessageHandlers(this.messageFactory, this._handlers);

  void handleMessage(Map json, WebSocket socket) {
    Message message = messageFactory.create(json);
    if (message != null) {
      _handlers.forEach((ConnectionMessageHandler handler) => handler.tryHandlingMessage(message, socket));
    }
  }
}
