import 'package:go_hoard_yourself/src/models/dragon.dart';

import '../models/food.dart';

class FoodKobold extends Food {
  @override
  String get id => 'kobold';

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
  void removeOne(Dragon dragon) {
    owned--;
    if (dragon.kobolds < dragon.koboldsInUse) {
      for (var task in dragon.unlockedTasks) {
        if (task.koboldsAssigned > 0) {
          task.koboldsAssigned--;
          break;
        }
      }
    }
  }

  @override
  int get salePrice => 1000;
}

final FoodKobold FOOD_KOBOLD = FoodKobold();

final Food FOOD_RABBIT = BasicFood(
  id: 'rabbit',
  name: 'Raw Rabbit',
  desc: 'A whole raw rabbit. Congratulations on the hunt!',
  eatTime: 20.0,
  size: 5.0,
  fatRatio: 0.5,
  digestionRate: 1.0,
  salePrice: 100,
);

final Food FOOD_DEER = BasicFood(
  id: 'deer',
  name: 'Raw Deer',
  desc: 'On one claw, you caught a whole deer! On the other, venison is pretty dang gamey. Ah well, better dig in.',
  eatTime: 40.0,
  size: 15.0,
  fatRatio: 0.5,
  digestionRate: 1.0,
  salePrice: 200,
);

final List<Food> FOODS = [
  FOOD_KOBOLD,
  FOOD_RABBIT,
  FOOD_DEER,
];
