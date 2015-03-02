import 'package:poker_planning_client/components/game/game.dart';

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';

class KickEventHandler extends MessageHandler<KickEvent> {
  GameComponent _game;

  KickEventHandler(this._game);

  void handleMessage(KickEvent message) {
    _game.handleKick(message);
  }
}
