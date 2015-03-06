library game_information_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/game_information.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/game.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/tuple.dart';

@Injectable()
class GameInformationHandler extends MessageHandler<GameInformation> {
  CurrentGame currentGame;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;

  GameInformationHandler(this.currentGame, this.scope, this.currentUser);

  void handleMessage(GameInformation message) {
    int gameId = message.gameId;
    Game newGame = message.game;
    bool revealed = message.revealed;

    logger.info("display cards with revealed : $revealed");

    currentGame.players.removeWhere((t) => !message.game.players.containsKey(t.first));

    newGame.players.forEach((String player, String card) {
      updateCard(player, card);
    });

    scope.rootScope.broadcast('game-update', revealed);
    scope.broadcast("card-update", [currentGame.players, revealed]);
  }

  void updateCard(String player, String card) {
    if (!currentGame.players.any((x) => x.first == player)) {
      currentGame.players.add(new Tuple(player, card));
    } else {
      currentGame.players.forEach((t) {
        if (t.first == player) {
          t.second = card;
          return;
        }
      });
    }
  }
}
