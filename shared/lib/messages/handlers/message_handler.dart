library message_handler;

import 'dart:async';
import '../message.dart';

abstract class MessageHandler<T extends Message> {
  Future tryHandlingMessage(Message message) async {
    if (message is T) {
      await handleMessage(message);
    }
  }

  Future handleMessage(T message);
}
