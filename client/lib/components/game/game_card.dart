library poker_planning_cards;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:poker_planning_client/analytics.dart';
import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';
import 'package:poker_planning_client/current_game.dart';

import 'package:poker_planning_shared/messages/card_selection_event.dart';

@Component(
    selector: 'game-card',
    cssUrl: 'packages/poker_planning_client/components/game/game_card.css',
    templateUrl: 'packages/poker_planning_client/components/game/game_card.html')
class GameCard implements ShadowRootAware, ScopeAware {
  @NgAttr("value")
  String value;
  var clickHandler;
  ShadowRoot shadowRoot;
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope _scope;
  CurrentGame currentGame;
  Analytics analytics;

  GameCard(this.socketCommunication, this.currentUser, this.currentGame, this.analytics);

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void setSelected(bool selected) {
    shadowRoot.querySelector("#valueContainer").classes.toggle("selected", selected);
  }

  void onCardSelected() {
    socketCommunication.sendSocketMsg(new CardSelectionEvent(currentGame.getGameId(), currentUser.userId, value));

    setSelected(true);

    analytics.sendEvent("Game", "Card selected", value);

    _scope.parentScope.broadcast("cardSelected", value);
  }

  void set scope(Scope scope) {
    _scope = scope;
    _scope.on("cardSelected").listen(cardSelected);
    _scope.on("game-has-reset").listen(deselectCard);
  }

  void cardSelected(ScopeEvent e) {
    if (e.data != value) {
      setSelected(false);
    }
  }

  void deselectCard(_) {
    setSelected(false);
  }
}
