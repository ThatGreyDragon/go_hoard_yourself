import 'dart:html';
import 'dart:js' as js;

import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'popup',
  templateUrl: 'popup.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class PopupComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  Element modal;
  bool open = false;

  static PopupComponent INSTANCE;

  PopupComponent() {
    INSTANCE = this;
  }

  String get title => dragon.popupQueue.isEmpty ? null : dragon.popupQueue[0].title;
  String get message => dragon.popupQueue.isEmpty ? null : dragon.popupQueue[0].message;

  void showPopup() {
    js.context.callMethod(r'$', [modal]).callMethod('modal', ['show']);
    open = true;
  }

  void onInit(Element e) {
    modal = e;
    js.context.callMethod(r'$', [modal]).callMethod('on', ['hidden.bs.modal	', js.allowInterop((e) {
      open = false;
      dragon.popupQueue.removeAt(0);
      if (dragon.popupQueue.isNotEmpty) {
        showPopup();
      }
    })]);
  }
}
