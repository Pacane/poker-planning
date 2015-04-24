library card_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:poker_planning_client/tuple.dart';
import 'package:poker_planning_shared/player.dart';

@Component(
    selector: 'game-player',
    cssUrl: 'packages/poker_planning_client/components/game/game_player.css',
    templateUrl: 'packages/poker_planning_client/components/game/game_player.html')
class GamePlayer implements ShadowRootAware, ScopeAware {
  @NgTwoWay("displayName")
  String displayName;
  @NgTwoWay("playerId")
  int playerId;
  @NgTwoWay("valueToDisplay")
  String valueToDisplay;
  @NgTwoWay("gameRevealed")
  bool revealed;
  @NgOneWay("value")
  String value;
  ShadowRoot _shadowRoot;
  Scope _scope;

  DivElement _cardDiv;

  void applyStyles() {
    if (value == "Y") {
      setClass("selected");
      valueToDisplay = "";
    } else if (revealed) {
      setClass("");
      valueToDisplay = value;
    } else if (value == "") {
      setClass("waiting");
      valueToDisplay = "";
    }
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
    _cardDiv = _shadowRoot.querySelector("#card");

    applyStyles();
  }

  void setClass(String classname) {
    _cardDiv.classes.clear();
    if (classname != "") {
      _cardDiv.classes.add(classname);
    }
  }

  void kickPlayer() {
    _scope.emit("kick-player", playerId);
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("card-update").listen(updateCard);
    scope.on("game-has-reset").listen(resetCard);
  }

  void resetCard(_) {
    revealed = false;
    setClass("");
    value = "";
    applyStyles();
  }

  void updateCard(ScopeEvent event) {
    List<Tuple<Player, String>> players = event.data[0];
    bool stillAPlayer = players.any((t) => t.first.id == playerId);
    if (stillAPlayer) {
      value = players.firstWhere((t) => t.first.id == playerId).second;
      revealed = event.data[1];
      applyStyles();
    }
  }
}
