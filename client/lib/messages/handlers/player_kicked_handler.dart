library kick_handler;

import 'dart:async';

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/player_kicked_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/player.dart';

import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

@Injectable()
class PlayerKickedHandler extends MessageHandler<PlayerKickedEvent> {
  CurrentGame game;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;

  PlayerKickedHandler(this.game, this.scope, this.currentUser);

  Future handleMessage(PlayerKickedEvent message) async {
    Player kickedPlayer = message.kickedPlayer;
    Player kickedBy = message.kickedBy;

    game.removePlayer(kickedPlayer);

    if (kickedPlayer.id == currentUser.userId) {
      String msg = "You have been kicked by: ${kickedBy.displayName}";
      scope.rootScope.broadcast("kicked", msg);
    } else {
      logger.warning("${kickedPlayer.displayName} has been kicked by ${kickedBy.displayName}");
    }
  }
}
