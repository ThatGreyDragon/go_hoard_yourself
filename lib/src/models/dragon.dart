import 'dart:convert';
import 'dart:html';

import 'package:go_hoard_yourself/src/data/banners.dart';
import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/data/upgrades.dart';
import 'package:go_hoard_yourself/src/models/banner.dart';
import 'package:go_hoard_yourself/src/models/building.dart';
import 'package:go_hoard_yourself/src/models/log.dart';
import 'package:go_hoard_yourself/src/models/stat.dart';
import 'package:go_hoard_yourself/src/models/upgrade.dart';

import '../data/tasks.dart';
import '../models/food.dart';
import '../models/task.dart';

import 'dart:math';

class StomachFilling {
  Food food;
  double amount;

  StomachFilling(this.food, this.amount);

  StomachFilling.fromJSON(dynamic json) {
    food = Food.fromID(json['food']);
    amount = json['amount'];
  }

  dynamic toJSON() => {
    'food': food.id,
    'amount': amount,
  };
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
  Stat allUpgradeCosts = Stat(1.0);
  double weight = 100.0;
  double eatingProgress = 0.0;
  Task workingOn;
  Food eating;
  List<Task> unlockedTasks = TASKS;
  List<Building> unlockedBuildings = BUILDINGS;
  List<Banner> unlockedBanners = BANNERS;
  List<Upgrade> unlockableUpgrades = List<Upgrade>.from(UPGRADES);
  List<Upgrade> unlockedUpgrades = [];
  List<LogEntry> log = [];
  int gold = 0;
  int sciencePoints = 0;

  bool foodUnlocked = false;
  bool koboldsUnlocked = false;
  bool goldUnlocked = false;
  bool scienceUnlocked = false;

  void _init() {
    metabolism.specialMods.add((value) => overfull ? value/2 : value);
    workSpeed.specialMods.add((value) => overfull ? value/2 : value);
  }

  Dragon(this.name) {
    _init();
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
  double upgradeCost(Upgrade upgrade) => allUpgradeCosts.value * upgrade.cost;
  bool canResearch(Upgrade upgrade) => sciencePoints >= upgradeCost(upgrade);

  dynamic toJSON() => {
    'name': name,
    'inventory': Map.fromEntries(inventory.entries.map(
      (e) => MapEntry(e.key.id, e.value)
    )),
    'stomach': stomach.map((filling) => filling.toJSON()).toList(),
    'weight': weight,
    'eatingProgress': eatingProgress,
    'workingOn': workingOn?.id,
    'eating': eating?.id,
    'tasks': unlockedTasks.map((task) => task.toJSON()).toList(),
    'buildings': unlockedBuildings.map((b) => b.toJSON()).toList(),
    'banners': unlockedBanners.map((b) => b.id).toList(),
    'unlockableUpgrades': unlockableUpgrades.map((u) => u.id).toList(),
    'unlockedUpgrades': unlockedUpgrades.map((u) => u.id).toList(),
    'gold': gold,
    'sciencePoints': sciencePoints,
    'unlocked': {
      'kobolds': koboldsUnlocked,
      'gold': goldUnlocked,
      'science': scienceUnlocked,
      'food': foodUnlocked,
    },
  };

  Dragon.fromJSON(dynamic json) {
    _init();

    name = json['name'];
    inventory = Map.fromEntries((json['inventory'] as Map).entries.map(
      (e) => MapEntry<Food, int>(Food.fromID(e.key), e.value)
    ));
    stomach = (json['stomach'] as List).map((f) => StomachFilling.fromJSON(f)).toSet();
    weight = json['weight'];
    eatingProgress = json['eatingProgress'];
    workingOn = Task.fromID(json['workingOn']);
    eating = Food.fromID(json['eating']);
    unlockedTasks = (json['tasks'] as List).map(
      (t) => Task.fromJSON(t)
    ).toList();
    unlockedBuildings = (json['buildings'] as List).map(
      (t) => Building.fromJSON(t)
    ).toList();
    unlockedBanners = (json['banners'] as List).map(
      (b) => Banner.fromID(b)
    ).toList();
    unlockableUpgrades = (json['unlockableUpgrades'] as List).map(
      (b) => Upgrade.fromID(b)
    ).toList();
    unlockedUpgrades = (json['unlockedUpgrades'] as List).map(
      (b) => Upgrade.fromID(b)
    ).toList();
    gold = json['gold'];
    sciencePoints = json['sciencePoints'];
    koboldsUnlocked = json['unlocked']['kobolds'];
    goldUnlocked = json['unlocked']['gold'];
    scienceUnlocked = json['unlocked']['science'];
    foodUnlocked = json['unlocked']['food'];

    for (var building in unlockedBuildings) {
      for (var i = 0; i < building.owned; i++) {
        building.onBought(this);
      }
    }
    for (var upgrade in unlockedUpgrades) {
      upgrade.onUnlock(this);
    }
  }

  void save() {
    window.localStorage['GHY_Savegame'] = jsonEncode(toJSON());
  }

  factory Dragon.load() {
    if (window.localStorage.containsKey('GHY_Savegame')) {
      return Dragon.fromJSON(jsonDecode(window.localStorage['GHY_Savegame']));
    } else {
      return Dragon('Testerino');
    }
  }
}
