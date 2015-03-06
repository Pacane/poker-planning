library reveal_handler;

import 'package:angular/angular.dart';

import "package:logging/logging.dart";

import 'package:poker_planning_shared/messages/reveal_request_event.dart';
import 'package:poker_planning_shared/messages/handlers/message_handler.dart';

import 'package:poker_planning_client/current_game.dart';
import 'package:poker_planning_client/current_user.dart';

@Injectable()
class RevealHandler extends MessageHandler<RevealRequestEvent> {
  CurrentGame game;
  CurrentUser currentUser;
  Scope scope;
  Logger logger = Logger.root;

  RevealHandler(this.game, this.scope, this.currentUser);

  void handleMessage(RevealRequestEvent message) {

  }
}
