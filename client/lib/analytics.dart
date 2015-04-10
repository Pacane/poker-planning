library analytics;

import 'dart:js';

import 'package:angular/angular.dart';

@Injectable()
class Analytics {
  void sendPageView(String path) {
    new JsObject(context['ga'], ['send', 'pageview', path]);
  }

  void sendEvent(String category, String action, [String label]) {
    new JsObject(context['ga'], ['send', 'event', category, action, label]);
  }
}
