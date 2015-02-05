library card_component;

import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';
import 'package:angular/angular.dart';

@Component(
    selector: 'table-card',
    cssUrl: 'packages/poker_planning_client/components/css/table_card.css',
    templateUrl: 'packages/poker_planning_client/components/table_card.html')
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
      setSelected(true);
      valueToDisplay = "...";
    } else if (revealed) {
      valueToDisplay = value;
      setSelected(false);
    } else if (value == "") {
      valueToDisplay = "...";
    }
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
    _cardDiv = _shadowRoot.querySelector("#card");

    applyStyles();
  }

  void setSelected(bool selected) {
    _cardDiv.classes.toggle("selected", selected);
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
    setSelected(false);
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
