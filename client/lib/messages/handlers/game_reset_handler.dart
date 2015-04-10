library game_reset_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/game_has_reset_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

@Injectable()
class GameHasResetHandler extends MessageHandler<GameHasResetEvent> {
  CurrentGame game;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;

  GameHasResetHandler(this.game, this.scope, this.currentUser);

  void handleMessage(GameHasResetEvent message) {
    game.players.forEach((t) => t.second = "");
    game.lastReset = message.lastReset;
    scope.rootScope.broadcast("game-has-reset", {});

    logger.info("Game has reset!");
  }
}
