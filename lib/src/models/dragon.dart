import '../data/tasks.dart';
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
  Map<Food,int> inventory = {};
  Set<StomachFilling> stomach = {};
  double stomachCapacity, metabolism, eatSpeed, weight, eatingProgress;
  Task workingOn;
  Food eating;
  List<Task> unlockedTasks = [];

  Dragon(this.name) {
    stomachCapacity = 10.0;
    metabolism = 1.0;
    eatSpeed = 1.0;
    weight = 100.0;
    eatingProgress = 0.0;
    unlockedTasks = [TASK_GATHER];
  }

  double get workSpeed => 0.1;

  void onTick() {
    // do work
    if (eating == null) {
      workingOn?.doWork(this, workSpeed);
    }

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
        if (exisitingFilling != null) {
          exisitingFilling.amount += eating.size;
        } else {
          stomach.add(StomachFilling(eating, eating.size));
        }
        var remaining = inventory.update(eating, (int i) => i-1);
        if (remaining <= 0) {
          inventory.remove(eating);
        }
        eatingProgress = 0.0;
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

  void giveFood(Food food, [int amount = 1]) {
    inventory.putIfAbsent(food, () => 0);
    inventory[food] += amount;
  }

  double get eatingProgressPercent => (eatingProgress / (eating?.eatTime ?? 1) * 100);
  String get eatingProgressPercentString => eatingProgressPercent.toStringAsFixed(0) + '%';
  double get stomachSpaceInUse => stomach.fold(0, (total, filling) => total + filling.amount);
}
