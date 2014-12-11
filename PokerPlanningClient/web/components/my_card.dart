library poker_planning_cards;

import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';

@CustomTag('my-card')
class MyCard extends PolymerElement {
  @observable String value;
  var clickHandler;

  MyCard.created() : super.created() {
  }

  factory MyCard.create(String value, clickHandler) {
    MyCard component = (new Element.tag("my-card") as MyCard)
      ..value = value
      ..clickHandler = clickHandler;

    return component;
  }

  void setSelected(bool selected) {
    $["valueContainer"].classes.toggle("selected", selected);
  }

  void onValueClicked(Event e, var detail, Node target) {
    clickHandler(value);
    clearSelectedCards();
    setSelected(true);
  }

  static void clearSelectedCards() => querySelectorAll("my-card").forEach((MyCard c) => c.setSelected(false));
}
