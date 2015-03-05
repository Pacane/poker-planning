library connection_message_handler;

import '../message.dart';
import 'dart:io';

abstract class ConnectionMessageHandler<T extends Message> {
  void tryHandlingMessage(Message message, WebSocket socket) {
    if (message is T) {
      handleMessage(message, socket);
    }
  }

  void handleMessage(T message, WebSocket socket);
}
