library time_resource;

import 'package:redstone/server.dart' as app;
import 'package:shelf/shelf.dart' as shelf;

@app.Group('/time')
class Time {
  @app.DefaultRoute()
  shelf.Response getTime() => new shelf.Response.ok(new DateTime.now().toIso8601String());
}
