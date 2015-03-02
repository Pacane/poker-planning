library message;

class Message {
  String type;
  Map content = {};

  Message(this.type, this.content) {
    if (type == null) {
      throw new ArgumentError.notNull('type');
    }
    if (content == null) {
      throw new ArgumentError.notNull('content');
    }
  }

  Map toJson() {
    Map map = new Map();
    map['type'] = type;
    map['content'] = content;
    return map;
  }
}