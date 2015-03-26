import 'package:unittest/unittest.dart';
import 'package:dart_config/default_server.dart';

import 'jira_crawler.dart';
import 'story.dart';

void main() {
  JiraCrawler crawler;
  String hostname = 'arcbees.atlassian.net';
  int rapidViewId = 49;

  setUp(() async {
    Map config = await loadConfig();
    crawler = new JiraCrawler(config['jira.authorizationHeader'], hostname, rapidViewId);
  });

  test('Get stories, should get json', () async {
    Iterable<Story> stories = await crawler.getStories();
    expect(stories.length, 2);
  });
}
