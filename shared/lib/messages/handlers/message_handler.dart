import '../message.dart';

abstract class MessageHandler<T extends Message> {
  void tryHandlingMessage(Message message) {
    if (message is T) {
      handleMessage(message);
    }
  }

  void handleMessage(T message);
}
