library interceptors;

import 'package:redstone/server.dart' as app;
import 'package:shelf/shelf.dart' as shelf;

@app.Group("/")
class Interceptors {
  @app.Interceptor(r'/.*')
  handleResponseHeader() {
    if (app.request.method == "OPTIONS") {
      //overwrite the current response and interrupt the chain.
      app.response = new shelf.Response.ok(null, headers: _createCorsHeader());
      app.chain.interrupt();
    } else {
      //process the chain and wrap the response
      app.chain.next(() => app.response.change(headers: _createCorsHeader()));
    }
  }

  _createCorsHeader() => {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods' : 'PUT, GET, POST, OPTIONS',
      'Access-Control-Allow-Headers' : 'Origin, X-Requested-With, Content-Type, Accept'
  };
}
