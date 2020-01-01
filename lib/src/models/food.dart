import 'package:go_hoard_yourself/src/models/dragon.dart';

abstract class Food {
  String get name;
  String get desc;
  double get eatTime;
  double get size;
  double get fatRatio;
  double get digestionRate;

  void onEat(Dragon dragon);
}

class BasicFood extends Food {
  @override
  String name, desc;

  @override
  double eatTime, size, fatRatio, digestionRate;

  @override
  void onEat(Dragon dragon) {
    dragon.fillStomach(this);
    dragon.takeFood(this);
  }

  BasicFood({this.name, this.desc, this.eatTime, this.size, this.fatRatio, this.digestionRate});
}
