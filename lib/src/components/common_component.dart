import 'package:angular/angular.dart' as angular;
import 'dart:js' as js;
import 'dart:async' as streams;
import 'dart:html' as html;

class CommonComponent {
  void _enableTooltips(html.Element e) {
    js.context.callMethod(r'$', ['[data-toggle="tooltip"]', e]).callMethod('tooltip');
    js.context.callMethod(r'$', ['[data-toggle="popover"]', e]).callMethod('popover');
  }

  void enableToolips(html.Element e) {
    _enableTooltips(e);
    html.MutationObserver((event, observer) {
      _enableTooltips(e);
    }).observe(e, childList: true);
  }
}

@angular.Directive(selector: '[init]')
class InitDirective implements angular.AfterContentInit {
  InitDirective() {
    stream = streamController.stream;
  }

  streams.StreamController streamController = streams.StreamController();

  @angular.Output('init')
  streams.Stream stream;

  @override
  void ngAfterContentInit() {
    streamController.add(null);
  }
}
