import 'package:unittest/unittest.dart';
import 'package:dart_config/default_server.dart';

import 'jira_crawler.dart';
import 'story.dart';

void main() {
  JiraCrawler crawler;
  String hostname = 'arcbees.atlassian.net';
  int rapidViewId = 53;
  String testStoryKey = "TA-1";

  setUp(() async {
    Map config = await loadConfig();
    crawler = new JiraCrawler(config['jira.authorizationHeader'], hostname, rapidViewId, 'customfield_10004');
  });

  test('Get stories, should get json', () async {
    Iterable<Story> stories = await crawler.getStories();
    expect(stories.length, 2);
  });

  test('Clear story points, should set 0', () async {
    await crawler.clearStoryPoints(testStoryKey);

    Story story = await crawler.getStory(testStoryKey);
    expect(story.storyPoints, 0);
  });

  test('Update story points, should set specified points', () async {
    int points = 3;

    await crawler.updateStoryPoints(testStoryKey, points);

    Story story = await crawler.getStory(testStoryKey);
    expect(story.storyPoints, points);
  });
}
