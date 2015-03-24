library game_information_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/game_information.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/game.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

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
    bool revealed = message.game.revealed;

    logger.info("display cards with revealed : $revealed");

    currentGame.removeDisconnectedPlayers(newGame);

    currentGame.updateCards(newGame);

    scope.rootScope.broadcast('game-update', revealed);
    scope.rootScope.broadcast("card-update", [currentGame.players, revealed]);
  }
}
