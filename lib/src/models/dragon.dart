import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/models/building.dart';
import 'package:go_hoard_yourself/src/models/log.dart';
import 'package:go_hoard_yourself/src/models/stat.dart';

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
  Stat stomachCapacity = Stat(10.0);
  Stat metabolism = Stat(0.1);
  Stat eatSpeed = Stat(1.0);
  Stat workSpeed = Stat(0.1);
  Stat koboldWorkSpeed = Stat(0.01);
  Stat allBuildingCosts = Stat(1.0);
  double weight = 100.0;
  double eatingProgress = 0.0;
  Task workingOn;
  Food eating;
  List<Task> unlockedTasks = TASKS;
  List<Building> unlockedBuildings = BUILDINGS;
  List<LogEntry> log = [];
  int gold = 0;
  int sciencePoints = 0;

  bool koboldsUnlocked = false;
  bool goldUnlocked = false;
  bool scienceUnlocked = false;

  Dragon(this.name) {
    metabolism.specialMods.add((value) => overfull ? value/2 : value);
    workSpeed.specialMods.add((value) => overfull ? value/2 : value);
  }

  void onTick() {
    // do work
    if (eating == null) {
      workingOn?.doWork(this, workSpeed.value);
    }
    for (var task in unlockedTasks) {
      task.doWork(this, koboldWorkSpeed.value * task.koboldsAssigned);
    }

    // eat food
    if (eating != null) {
      eatingProgress += eatSpeed.value;
      if (eatingProgress >= eating.eatTime) {
        eating.onEat(this);
        eatingProgress = 0.0;
        eating = null;
      }
    }

    // digest food
    var toDelete = <StomachFilling>{}; 
    for (var filling in stomach) {
      var amount = min(metabolism.value * filling.food.digestionRate, filling.amount);
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
  double get stomachFullPercent => stomachSpaceInUse / stomachCapacity.value;
  bool get overfull => stomachFullPercent > 1;

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

  double buildingCost(Building building) => allBuildingCosts.value * building.cost;
  bool affordable(Building building) => gold >= buildingCost(building);
}
