library jira_crawler;

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' show JSON;
import 'story.dart';
import 'dart:async';

class JiraCrawler {
  String authorizationHeader;
  String hostname;
  String boardUrl;
  int rapidViewId;

  JiraCrawler(this.authorizationHeader, this.hostname, this.rapidViewId) {
    boardUrl = 'https://$hostname/rest/greenhopper/1.0/xboard/plan/backlog/data?rapidViewId=$rapidViewId';
  }

  Future<Iterable<Story>> getStories() {
    var client = new http.Client();
    return client
        .get(boardUrl, headers: {"Authorization": "$authorizationHeader", "Content-Type": "application/json"})
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
}
