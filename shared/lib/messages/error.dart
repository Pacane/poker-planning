import 'message.dart';

class Error extends Message {
  Error(Map content) : super('error', content) {
    if (content == null) {
      throw new ArgumentError.notNull('content');
    }
    if (content['message'] == null) {
      throw new ArgumentError.notNull('message');
    }
  }
}