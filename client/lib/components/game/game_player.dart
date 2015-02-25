library card_component;

import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';
import 'package:angular/angular.dart';

@Component(
    selector: 'game-player',
    cssUrl: 'packages/poker_planning_client/components/game/game_player.css',
    templateUrl: 'packages/poker_planning_client/components/game/game_player.html')
class TableCard implements ShadowRootAware, ScopeAware {
  @NgTwoWay("playerName")
  String playerName;
  @NgTwoWay("valueToDisplay")
  String valueToDisplay;
  @NgTwoWay("revealed")
  bool revealed;
  @NgOneWay("value")
  String value;
  ShadowRoot _shadowRoot;
  Scope _scope;

  String _value;
  var _kickHandler;
  ButtonElement _kickButton;
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
    if(classname != "") {
      _cardDiv.classes.add(classname);
    }
  }

  void kickPlayer() {
    _scope.emit("kick-player", playerName);
  }

  void set scope(Scope scope) {
    this._scope = scope;
    scope.on("card-update").listen(updateCard);
    scope.on("game-has-reset").listen(resetCard);
  }

  void resetCard(_) {
    setClass("");
    value = "";
    valueToDisplay = "...";
  }

  void updateCard(ScopeEvent event) {
    Map game = event.data[0];
    value = game[playerName];
    revealed = event.data[1];
    applyStyles();
  }
}
