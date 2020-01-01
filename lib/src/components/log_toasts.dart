import 'dart:html' as html;
import 'dart:js' as js;

import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

@Component(
  selector: 'log-toasts',
  templateUrl: 'log_toasts.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class LogToastsComponent extends CommonComponent {
  static final int MAX_TOASTS_ON_SCREEN = 4;

  @Input()
  Dragon dragon;

  String logColor(LogEntry entry) {
    switch (entry.type) {
      case LogType.INFO:
        return 'alert-secondary';
      case LogType.GOOD:
        return 'alert-success';
      case LogType.BAD:
        return 'alert-danger';
    }
  }

  void onInit(html.DivElement toastPanel) {
    html.MutationObserver((mutations, observer) {
      print('chuldren: ${toastPanel.children.length}');
      for (var child in List<html.Element>.from(toastPanel.children)) {
        if (child.children.isEmpty) {
          child.remove();
        }
      }
      if (toastPanel.children.length > MAX_TOASTS_ON_SCREEN) {
        js.context.callMethod(r'$', ['.alert']).callMethod('slice', [0, -MAX_TOASTS_ON_SCREEN]).callMethod('alert', ['close']);
      }
    }).observe(toastPanel, childList: true);
  }
}
