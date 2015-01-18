library poker_planning_cards;

import 'package:angular/angular.dart';
import 'dart:html' show Event, Node, CustomEvent;
import 'dart:html';

import 'package:poker_planning_client/socket_communication.dart';
import 'package:poker_planning_client/current_user.dart';

@Component(
    selector: 'my-card',
    cssUrl: 'packages/poker_planning_client/components/my_card.css',
    templateUrl: 'packages/poker_planning_client/components/my_card.html')
class MyCard implements ShadowRootAware, ScopeAware {
  @NgAttr("value")
  String value;
  var clickHandler;
  ShadowRoot shadowRoot;
  SocketCommunication socketCommunication;
  CurrentUser currentUser;
  Scope _scope;

  MyCard(this.socketCommunication, this.currentUser);

  void onShadowRoot(ShadowRoot shadowRoot) {
    this.shadowRoot = shadowRoot;
  }

  void setSelected(bool selected) {
    shadowRoot.querySelector("#valueContainer").classes.toggle("selected", selected);
  }

  void onCardSelected() {
    socketCommunication.sendSocketMsg({
        "cardSelection": [currentUser.userName, value]
    });
    setSelected(true);

    _scope.parentScope.broadcast("cardSelected", [value]);
  }

  static void clearSelectedCards() => querySelectorAll("my-card").forEach((MyCard c) => c.setSelected(false));

  void set scope(Scope scope) {
    _scope = scope;
    _scope.on("cardSelected").listen(cardSelected);
  }

  void cardSelected(ScopeEvent e) {
    if (e.data != value) {
      setSelected(false);
    }
  }

}
