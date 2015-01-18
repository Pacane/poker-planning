library card_component;

import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';
import 'package:angular/angular.dart';

@Component(
    selector: 'table-card',
    cssUrl: 'packages/poker_planning_client/components/table_card.css',
    templateUrl: 'packages/poker_planning_client/components/table_card.html')
class TableCard implements AttachAware, ShadowRootAware {
  @NgTwoWay("playerName")
  String playerName;
  @NgTwoWay("valueToDisplay")
  String valueToDisplay;

  bool revealed;
  ShadowRoot shadowRoot;

  String _value;
  var _kickHandler;
  ButtonElement _kickButton;
  DivElement _cardDiv;

  void set value(String newValue) {
    _value = newValue;
    valueToDisplay = revealed ? _value : "...";
  }

  String get value => _value;

//  factory TableCard.create(String playerName, String value, bool revealed, kickHandler) {
//    TableCard component = (new Element.tag("table-card") as TableCard)
//      ..playerName = playerName
//      ..revealed = revealed
//      ..value = value
//      .._kickHandler = kickHandler;
//
//    return component;
//  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void attach() {
    _cardDiv = shadowRoot.querySelector("#card");
    setSelected();

    _kickButton = shadowRoot.querySelector("#kickPlayer")
      ..onClick.listen((e) => _kickHandler(playerName));
  }

  void setSelected() {
    _cardDiv.classes.toggle("selected", revealed ? false : value != "");
  }

  void selectCard(Event e) {
    _cardDiv.classes.toggle("selected");
  }
}
