import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/food.dart';

@Component(
  selector: 'food',
  templateUrl: 'food.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class FoodComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  Object trackByInvetoryLength(_, dynamic o) => dragon.inventory.length;

  bool beingEaten(Food food) {
    return dragon.eating == food;
  }

  void onFoodSelected(Food food) {
    dragon.eatingProgress = 0.0;
    if (dragon.eating == food) {
      dragon.eating = null;
    } else {
      dragon.eating = food;
    }
  }
}
