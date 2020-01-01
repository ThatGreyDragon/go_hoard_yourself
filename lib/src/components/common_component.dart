import 'package:angular/angular.dart' as angular;
import 'dart:js' as js;
import 'dart:async';

class CommonComponent implements angular.AfterContentChecked {
  @override
  void ngAfterContentChecked() {
    js.context.callMethod(r'$', ['[data-toggle="tooltip"]']).callMethod('tooltip');
    js.context.callMethod(r'$', ['[data-toggle="popover"]']).callMethod('popover');
  }
}

@angular.Directive(selector: '[init]')
class InitDirective implements angular.AfterContentInit {
  InitDirective() {
    stream = streamController.stream;
  }

  StreamController streamController = StreamController();

  @angular.Output('init')
  Stream stream;

  @override
  void ngAfterContentInit() {
    streamController.add(null);
  }
}
