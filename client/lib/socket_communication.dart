library socket_communication;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:angular/angular.dart';

import "package:logging/logging.dart";

@Injectable()
class SocketCommunication {
  String hostname;
  int port;
  WebSocket ws;
  Logger logger = Logger.root;

  SocketCommunication(this.hostname, this.port);

  void initWebSocket([retrySeconds = 2]) {
    logger.info("Connecting to websocket");
    ws = new WebSocket('ws://$hostname:$port/ws');

    ws.onOpen.listen((_) => logger.info("Connected"));

    ws.onClose.listen((e) {
      logger.info('Websocket closed');
    });

    ws.onError.listen((e) {
      logger.warning("Error connecting to ws");
    });

    ws.onMessage.listen((MessageEvent e) => logger.info(e.data));
  }

  void sendSocketMsg(Object jsObject) {
    if (ws != null && ws.readyState == WebSocket.CONNECTING) {
      new Future.delayed(new Duration(microseconds: 1), () => sendSocketMsg(jsObject));
    } else {
      ws.send(JSON.encode(jsObject));
    }
  }

  void close() {
    ws.close();
  }
}
