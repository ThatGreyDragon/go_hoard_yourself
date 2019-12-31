import '../models/food.dart';
import '../models/task.dart';

import 'dart:math';

class StomachFilling {
  Food food;
  double amount;

  StomachFilling(this.food, this.amount);
}

class Dragon {
  String name;
  Map<Food,int> food;
  Set<StomachFilling> stomach;
  double stomachCapacity, metabolism, eatSpeed, weight, eatingProgress;
  Task workingOn;
  Food eating;

  Dragon(this.name) {
    stomachCapacity = 10.0;
    metabolism = 1.0;
    eatSpeed = 1.0;
    weight = 100.0;
    eatingProgress = 0.0;
  }

  double get workSpeed => 0.1;

  void onTick() {
    // do work
    workingOn?.doWork(workSpeed);

    // eat food
    if (eating != null) {
      eatingProgress += eatSpeed;
      if (eatingProgress >= eating.eatTime) {
        StomachFilling exisitingFilling;
        for (var filling in stomach) {
          if (filling.food == eating) {
            exisitingFilling = filling;
            break;
          }
        }
        if (exisitingFilling == null) {
          exisitingFilling.amount += eating.size;
        } else {
          stomach.add(StomachFilling(eating, eating.size));
        }
        eating = null;
      }
    }

    // digest food
    var toDelete = <StomachFilling>{}; 
    for (var filling in stomach) {
      var amount = min(metabolism * filling.food.digestionRate, filling.amount);
      filling.amount -= amount;
      if (filling.amount <= 0) {
        toDelete.add(filling);
      }
      weight += amount * filling.food.fatRatio;
    }
    stomach.removeAll(toDelete);
  }
}
