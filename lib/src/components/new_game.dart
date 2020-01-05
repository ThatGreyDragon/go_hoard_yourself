import 'dart:html';
import 'dart:js' as js;

import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'new-game',
  templateUrl: 'new_game.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class NewGameComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  Element modal;
  bool open = false;

  static NewGameComponent INSTANCE;

  NewGameComponent() {
    INSTANCE = this;
  }

  void showNewGame() {
    js.context.callMethod(r'$', [modal]).callMethod('modal', ['show']);
    open = true;
  }

  void onInit(Element modal, InputElement nameInput) {
    this.modal = modal;
    js.context.callMethod(r'$', [modal]).callMethod('on', ['hidden.bs.modal	', js.allowInterop((e) {
      open = false;
      dragon.name = nameInput.value;
      nameInput.value = '';
    })]);

    if (dragon.name == null) {
      showNewGame();
    }
  }

  void closeNewGame() {
    js.context.callMethod(r'$', [modal]).callMethod('modal', ['hide']);
  }
}
