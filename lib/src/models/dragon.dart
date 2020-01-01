import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

import '../data/tasks.dart';
import '../models/food.dart';
import '../models/task.dart';

import 'dart:math';

final double BASE_KOBOLD_WORK = 0.01;

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
  List<LogEntry> log = [];
  int gold = 0;
  int sciencePoints = 0;

  bool koboldsUnlocked = false;
  bool goldUnlocked = false;
  bool scienceUnlocked = false;

  Dragon(this.name) {
    stomachCapacity = 10.0;
    metabolism = 0.1;
    eatSpeed = 1.0;
    weight = 100.0;
    eatingProgress = 0.0;
    unlockedTasks = [TASK_GATHER, TASK_EXPLORE_CAVE];
  }

  double get workSpeed => 0.1;

  void onTick() {
    // do work
    if (eating == null) {
      workingOn?.doWork(this, workSpeed);
    }
    for (var task in unlockedTasks) {
      task.doWork(this, BASE_KOBOLD_WORK * task.koboldsAssigned);
    }

    // eat food
    if (eating != null) {
      eatingProgress += eatSpeed;
      if (eatingProgress >= eating.eatTime) {
        eating.onEat(this);
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

  double get eatingProgressPercent => eatingProgress / (eating?.eatTime ?? 1);
  double get stomachSpaceInUse => stomach.fold(0, (total, filling) => total + filling.amount);
  double get stomachFullPercent => stomachSpaceInUse / stomachCapacity;

  int get kobolds => inventory[FOOD_KOBOLD] ?? 0;
  int get koboldsInUse => unlockedTasks.fold(0, (total, task) => total + task.koboldsAssigned);

  void fillStomach(Food food) {
    StomachFilling exisitingFilling;
    for (var filling in stomach) {
      if (filling.food == food) {
        exisitingFilling = filling;
        break;
      }
    }
    if (exisitingFilling != null) {
      exisitingFilling.amount += food.size;
    } else {
      stomach.add(StomachFilling(food, food.size));
    }
  }

  void takeFood(Food food, [int amount = 1]) {
    var remaining = inventory.update(food, (int i) => i - amount);
    if (remaining <= 0) {
      inventory.remove(food);
    }
  }
}
