library story;

class Story {
  int id;
  String key;
  String summary;
  bool done;
  int storyPoints;

  Story() {}

  static _toInt(double field) => field == null ? 0 : field.toInt();

  factory Story.fromMap(Map map) {
    return new Story()
      ..id = map["id"]
      ..key = map["key"]
      ..summary = map["summary"]
      ..done = map["done"]
      ..storyPoints = _toInt(map["estimateStatistic"]["statFieldValue"]["value"]);
  }

  String toString() {
    return 'Id: $id, Key: $key, Summary: $summary, Done: $done, StoryPoint: $storyPoints \n';
  }
}
