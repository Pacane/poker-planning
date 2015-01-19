library socket_communication;

import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';

@Injectable()
class SocketCommunication {
  String hostname;
  int port;
  WebSocket ws;

  SocketCommunication(this.hostname, this.port);

  void initWebSocket([retrySeconds = 2]) {
    print("Connecting to websocket");
    ws = new WebSocket('ws://$hostname:$port/ws');

    ws.onOpen.listen((_) => print("Connected"));

    ws.onClose.listen((e) {
      print('Websocket closed, retrying in $retrySeconds seconds');
    });

    ws.onError.listen((e) {
      print("Error connecting to ws");
    });

    ws.onMessage.listen((MessageEvent e) => print(e.data));
  }

  void sendSocketMsg(Object jsObject) {
    ws.send(JSON.encode(jsObject));
  }

  void close() {
    ws.close();
  }
}
