import 'package:go_hoard_yourself/src/models/dragon.dart';

import '../models/food.dart';

class FoodKobold extends Food {
  @override
  String get name => 'Kobold';

  @override
  String get desc => 'A short, scaly friend who\'s strangely eager to work for you. Or instead you could sample one...';

  @override
  double get digestionRate => 1.0;

  @override
  double get eatTime => 20.0;

  @override
  double get fatRatio => 0.5;

  @override
  double get size => 20.0;

  @override
  void onEat(Dragon dragon) {
    // do normal food behavior...
    dragon.fillStomach(this);
    dragon.takeFood(this);

    /// ... but also reduce kobold count
    if (dragon.kobolds < dragon.koboldsInUse) {
      for (var task in dragon.unlockedTasks) {
        if (task.koboldsAssigned > 0) {
          task.koboldsAssigned--;
          break;
        }
      }
    }
  }
}

final FoodKobold FOOD_KOBOLD = FoodKobold();

final Food FOOD_BURGER = BasicFood(
  name: 'Burger',
  desc: 'Mmm. Greasy!',
  eatTime: 10.0,
  size: 10.0,
  fatRatio: 1.0,
  digestionRate: 1.0,
);

final List<Food> FOODS = [
  FOOD_BURGER,
  FOOD_KOBOLD,
];
