import 'dart:html' as html;

import 'package:go_hoard_yourself/src/components/buildings.dart';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/components/food.dart';
import 'package:go_hoard_yourself/src/components/log.dart';
import 'package:go_hoard_yourself/src/components/log_toasts.dart';
import 'package:go_hoard_yourself/src/components/new_game.dart';
import 'package:go_hoard_yourself/src/components/popup.dart';
import 'package:go_hoard_yourself/src/components/settings.dart';
import 'package:go_hoard_yourself/src/components/tasks.dart';
import 'package:go_hoard_yourself/src/components/dragon_info.dart';
import 'package:go_hoard_yourself/src/components/upgrades.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

import 'package:angular/angular.dart';

import 'dart:async';

final int TICKS_PER_SECOND = 30;
final String VERSION = '0.1.0';

@Component(
  selector: 'go-hoard-yourself',
  styleUrls: ['go_hoard_yourself.css'],
  templateUrl: 'go_hoard_yourself.html',
  directives: [
    coreDirectives,
    InitDirective,
    DragonInfoComponent,
    TasksComponent,
    FoodComponent,
    LogComponent,
    LogToastsComponent,
    BuildingsComponent,
    UpgradesComponent,
    SettingsComponent,
    PopupComponent,
    NewGameComponent,
  ],
  pipes: [commonPipes],
)
class GoHoardYourself extends CommonComponent {
  static Dragon dragon = Dragon.load();

  GoHoardYourself() {
    Timer.periodic(
      Duration(milliseconds: 1000 ~/ TICKS_PER_SECOND),
      (Timer t) => dragon.onTick(),
    );

    Timer.periodic(
      Duration(milliseconds: 10000),
      (Timer t) => saveGame(),
    );

    html.window.onBeforeUnload.listen((event) => saveGame());
    html.window.onUnload.listen((event) => saveGame());
  }

  void saveGame() {
    if (SettingsComponent.autosave) {
      dragon.save();
    }
  }
}
