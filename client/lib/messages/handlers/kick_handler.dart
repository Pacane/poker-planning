library kick_handler;

import 'dart:async';

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/kick_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/player.dart';

import 'package:poker_planning_client/services/player_service.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

@Injectable()
class KickHandler extends MessageHandler<KickEvent> {
  CurrentGame game;
  CurrentUser currentUser;
  PlayerService playerService;
  Scope scope;
  Logger logger = Logger.root;

  KickHandler(this.game, this.scope, this.currentUser, this.playerService);

  Future handleMessage(KickEvent message) async {
    int kicked = message.kickedPlayerId;
    int kickedBy = message.kickedBy;
    Player playerWhoKicked = await playerService.getPlayer(kickedBy);

    game.players.removeWhere((Tuple<Player, String> t) => t.first.id == kicked);

    if (kicked == currentUser.userId) {
      String msg = "you have been kicked by: ${playerWhoKicked.displayName}";
      scope.rootScope.broadcast("kicked", msg);
    } else {
      Player kickedPlayer = await playerService.getPlayer(kicked);
      logger.warning("${kickedPlayer.displayName} has been kicked by ${playerWhoKicked.displayName}");
    }
  }
}
