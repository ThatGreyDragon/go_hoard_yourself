import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

enum Priority {
  DO_NOT_EAT,
  VERY_LOW,
  LOW,
  MEDIUM,
  HIGH,
  VERY_HIGH,
}

abstract class Food {
  String get id;
  String get name;
  String get desc;
  double get eatTime;
  double get size;
  double get fatRatio;
  double get digestionRate;
  int get salePrice;

  int owned = 0;
  bool sellable = false;
  Priority priority = Priority.DO_NOT_EAT;
  
  void onEat(Dragon dragon) {
    dragon.fillStomach(this);
    removeOne(dragon);
  }

  void removeOne(Dragon dragon) {
    owned--;
  }

  dynamic toJSON() => {
    'id': id,
    'owned': owned,
    'sellable': sellable,
    'priority': priority.index,
  };

  Food();
  factory Food.fromJSON(dynamic json) {
    var food = Food.fromID(json['id']);
    food.owned = json['owned'];
    food.sellable = json['sellable'];
    food.priority = Priority.values[json['priority']];
    return food;
  }
  factory Food.fromID(String id) => FOODS.firstWhere((f) => f.id == id, orElse: () => null);
}

class BasicFood extends Food {
  @override
  String id, name, desc;

  @override
  double eatTime, size, fatRatio, digestionRate;

  @override
  int salePrice;

  BasicFood({this.id, this.name, this.desc, this.eatTime, this.size, this.fatRatio, this.digestionRate, this.salePrice});
}
