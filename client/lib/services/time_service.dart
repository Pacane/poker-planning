library time_sync_service;

import 'package:angular/angular.dart';
import 'dart:async';

import 'package:poker_planning_client/services/api_paths.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

@Injectable()
class TimeService {
  ApiPaths paths;
  http.Client client = new BrowserClient();

  TimeService(this.paths);

  Future<Duration> getTimeDifference() async {
    DateTime now = new DateTime.now();
    http.Response response = await client.get(paths.getServerTime());

    DateTime serverTime = DateTime.parse(response.body);

    return serverTime.difference(now);
  }

  String getFormattedRemainingTime(Duration elapsedTime) {
    String unformattedTime = elapsedTime.toString();
    return unformattedTime.substring(0, unformattedTime.indexOf('.'));
  }
}
