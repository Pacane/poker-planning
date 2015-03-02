import '../message.dart';

abstract class MessageHandler {
  String messageType;

  MessageHandler(this.messageType);

  void tryHandlingMessage(Message message) {
    if (this.messageType == message.type) {
      handleMessage(message);
    }
  }

  void handleMessage(Message message);
}