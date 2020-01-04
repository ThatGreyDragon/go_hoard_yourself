import 'dart:html' as html;

import 'package:go_hoard_yourself/src/components/buildings.dart';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/components/food.dart';
import 'package:go_hoard_yourself/src/components/log.dart';
import 'package:go_hoard_yourself/src/components/log_toasts.dart';
import 'package:go_hoard_yourself/src/components/tasks.dart';
import 'package:go_hoard_yourself/src/components/dragon_info.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

import 'package:angular/angular.dart';

import 'dart:async';

final int TICKS_PER_SECOND = 30;

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
  ],
  pipes: [commonPipes],
)
class GoHoardYourself extends CommonComponent {
  Dragon dragon = Dragon('Testerino');

  GoHoardYourself() {
    Timer.periodic(
      Duration(milliseconds: 1000 ~/ TICKS_PER_SECOND),
      (Timer t) => dragon.onTick(),
    );
  }
}
