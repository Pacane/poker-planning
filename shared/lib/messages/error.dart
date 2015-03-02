import 'message.dart';

class ErrorEvent extends Message {
  static const String MSG_TYPE = "error";

  String message;

  ErrorEvent(this.message) : super(MSG_TYPE) {
    if (content['message'] == null) {
      throw new ArgumentError.notNull('message');
    }
  }

  factory ErrorEvent.fromJson(Map content) {
    return new ErrorEvent(content['message']);
  }

  void setContent() {
    content['message'] = message;
  }
}
