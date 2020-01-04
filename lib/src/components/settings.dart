import 'package:go_hoard_yourself/go_hoard_yourself.dart';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'settings',
  templateUrl: 'settings.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class SettingsComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  String get version => VERSION;
}
