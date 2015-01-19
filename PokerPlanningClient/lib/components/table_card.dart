library card_component;

import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';
import 'package:angular/angular.dart';

@Component(
    selector: 'table-card',
    cssUrl: 'packages/poker_planning_client/components/table_card.css',
    templateUrl: 'packages/poker_planning_client/components/table_card.html')
class TableCard implements ShadowRootAware {
  @NgTwoWay("playerName")
  String playerName;
  @NgTwoWay("valueToDisplay")
  String valueToDisplay;
  @NgTwoWay("revealed")
  bool revealed;
  ShadowRoot _shadowRoot;

  String _value;
  var _kickHandler;
  ButtonElement _kickButton;
  DivElement _cardDiv;

  void onShadowRoot(ShadowRoot shadowRoot) {
    _shadowRoot = shadowRoot;
    _cardDiv = _shadowRoot.querySelector("#card");

    print("vtd: $valueToDisplay revealed:$revealed");

    if (valueToDisplay == 'Y' && !revealed) {
      valueToDisplay = "...";
      setSelected(true);
    } else if (valueToDisplay == "" && !revealed) {
      valueToDisplay = "...";
      setSelected(false);
    }
  }

  bool setSelected(bool selected) =>  _cardDiv.classes.toggle("selected", selected);
}
