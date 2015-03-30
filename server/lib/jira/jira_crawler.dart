library jira_crawler;

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' show JSON;
import 'story.dart';
import 'dart:async';

class JiraCrawler {
  String authorizationHeader;
  String hostname;
  int rapidViewId;
  String storyPointsFieldId;
  String getStoriesUrl;
  String updateStoryUrl;

  JiraCrawler(this.authorizationHeader, this.hostname, this.rapidViewId, this.storyPointsFieldId) {
    getStoriesUrl = 'https://$hostname/rest/greenhopper/1.0/xboard/plan/backlog/data?rapidViewId=$rapidViewId';
    updateStoryUrl = 'https://$hostname/rest/greenhopper/1.0/xboard/issue/update-field';
  }

  Future<Story> getStory(String key) async {
    Iterable<Story> stories = await getStories();
    return stories.singleWhere((s) => s.key == key);
  }

  Future<Iterable<Story>> getStories() {
    var client = new http.Client();
    return client
        .get(getStoriesUrl, headers: {"Authorization": "$authorizationHeader", "Content-Type": "application/json"})
        .then((response) {
      if (response.statusCode == HttpStatus.OK) {
        Map content = JSON.decode(response.body);
        List issues = content["issues"];

        Iterable<Story> stories =
            issues.where((Map issue) => issue["typeName"] == "Story").map((Map issue) => new Story.fromMap(issue));

        return stories;
      } else {
        throw new Exception("Cannot connect to JIRA.");
      }
    })
      ..catchError((error) => throw error)
      ..whenComplete(() => client.close());
  }

  Future clearStoryPoints(String issueIdOrKey) {
    return updateStoryPoints(issueIdOrKey, 0);
  }

  Future updateStoryPoints(String issueIdOrKey, int points) {
    var client = new http.Client();
    return client.put(updateStoryUrl,
        headers: {"Authorization": "$authorizationHeader", "Content-Type": "application/json"},
        body: '{"fieldId": "$storyPointsFieldId","issueIdOrKey": "$issueIdOrKey","newValue": "$points"}');
  }
}
