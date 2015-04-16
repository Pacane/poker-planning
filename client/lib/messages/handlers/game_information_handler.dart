library game_information_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/game_information.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';
import 'package:poker_planning_shared/game.dart';
import 'package:poker_planning_shared/player.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/services/game_service.dart';

@Injectable()
class GameInformationHandler extends MessageHandler<GameInformation> {
  CurrentGame currentGame;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;
  GameService gameService;

  GameInformationHandler(this.currentGame, this.scope, this.currentUser, this.gameService);

  Future handleMessage(GameInformation message) async {
    Game newGame = message.game;
    bool revealed = message.game.revealed;

    List<Player> players = await gameService.getPlayers(currentGame.getGameId());

    logger.info("display cards with revealed : $revealed");

    currentGame.removeDisconnectedPlayers(newGame);
    currentGame.updateCards(newGame, players);
    currentGame.lastReset = message.game.lastReset;

    scope.rootScope.broadcast('game-update', revealed);
    scope.rootScope.broadcast("card-update", [currentGame.players, revealed]);
  }
}
