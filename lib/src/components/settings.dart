import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:go_hoard_yourself/go_hoard_yourself.dart';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/data/tasks.dart';
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

  void loadGame() {
    GoHoardYourself.dragon = Dragon.load();
    GoHoardYourself.dragon.log.add(LogEntry('Game loaded successfully.'));
  }

  void resetGame() {
    GoHoardYourself.dragon = Dragon('Testerino');
    for (var task in TASKS) {
      task.progress = 0.0;
      task.koboldsAssigned = 0;
    }
    for (var building in BUILDINGS) {
      building.owned = 0;
    }

    GoHoardYourself.dragon.log.add(LogEntry('Game reset successfully.'));
    if (autosave) {
      GoHoardYourself.dragon.save();
    }
  }

  void importGame(String b64save) {
    GoHoardYourself.dragon = Dragon.fromJSON(jsonDecode(utf8.decode(base64.decode(b64save))));
    GoHoardYourself.dragon.log.add(LogEntry('Game imported successfully.'));
    if (autosave) {
      GoHoardYourself.dragon.save();
    }
  }

  String get exportGame => base64.encode(utf8.encode(jsonEncode(dragon.toJSON())));
}
