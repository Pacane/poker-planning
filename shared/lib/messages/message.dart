library message;

abstract class Message {
  String type;
  Map content = {};

  Message(this.type) {
    if (type == null) {
      throw new ArgumentError.notNull('type');
    }
  }

  void setContent();

  Map toJson() {
    Map map = new Map();
    map['type'] = type;
    map['content'] = content;

    setContent();

    return map;
  }
}
