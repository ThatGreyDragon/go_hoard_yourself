import 'package:angular/angular.dart' as angular;
import 'dart:js' as js;

class CommonComponent implements angular.AfterContentChecked {
  @override
  void ngAfterContentChecked() {
    js.context.callMethod('eval', ['''
      \$(function () {
        \$('[data-toggle="tooltip"]').tooltip()
        \$('[data-toggle="popover"]').popover()
      })
    ''']);
  }
}
