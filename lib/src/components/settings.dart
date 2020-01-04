import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:go_hoard_yourself/go_hoard_yourself.dart';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

@Component(
  selector: 'settings',
  templateUrl: 'settings.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class SettingsComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  static bool autosave = true;

  String get version => VERSION;

  SettingsComponent() {
    loadSettings();

    Timer.periodic(
      Duration(milliseconds: 1000),
      (Timer t) => saveSettings(),
    );

    window.onBeforeUnload.listen((event) => saveSettings());
    window.onUnload.listen((event) => saveSettings());
  }

  void saveSettings() {
    window.localStorage['GHY_Settings'] = jsonEncode({
      'autosave': autosave,
    });
  }

  void loadSettings() {
    if (window.localStorage.containsKey('GHY_Settings')) {
      var json = jsonDecode(window.localStorage['GHY_Settings']);
      autosave = json['autosave'];
    }
  }

  void saveGame() {
    saveSettings();
    dragon.save();
    dragon.log.add(LogEntry('Game saved successfully.'));
  }
}