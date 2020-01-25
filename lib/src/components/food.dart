import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/food.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

@Component(
  selector: 'food',
  templateUrl: 'food.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class FoodComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  Iterable<Food> get foodUnlocked => FOODS.where((f)=>f.owned > 0);

  bool beingEaten(Food food) {
    return dragon.eating == food;
  }

  void onFoodSelected(Food food) {
    dragon.eatingProgress = 0.0;
    if (dragon.eating == food) {
      dragon.eating = null;
    } else {
      if (dragon.stomachFullPercent > 1) {
        dragon.log.add(LogEntry('You\'re overfull! You can\'t eat another bite!', LogType.BAD));
      } else {
        dragon.eating = food;
      }
    }
  }

  void onPriorityChange(Food food, int selIndex) {
    food.priority = Priority.values[selIndex];
  }
}
