library kick_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

@Injectable()
class KickHandler extends MessageHandler<KickEvent> {
  CurrentGame game;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;

  KickHandler(this.game, this.scope, this.currentUser);

  void handleMessage(KickEvent message) {
    int gameId = message.gameId;

    String kicked = message.kicked;
    String kickedBy = message.kickedBy;

    game.players.removeWhere((p) => p.first == kicked);

    if (kicked == currentUser.userName) {
      var msg = "you have been kicked by: $kickedBy";
      scope.rootScope.broadcast("kicked", msg);
    } else {
      logger.warning("$kicked has been kicked by $kickedBy");
    }
  }
}
