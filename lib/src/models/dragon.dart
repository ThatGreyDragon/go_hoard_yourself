import 'dart:convert';
import 'dart:html';

import 'package:go_hoard_yourself/src/components/new_game.dart';
import 'package:go_hoard_yourself/src/components/popup.dart';
import 'package:go_hoard_yourself/src/data/banners.dart';
import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/data/foods.dart';
import 'package:go_hoard_yourself/src/data/upgrades.dart';
import 'package:go_hoard_yourself/src/data/weight_milestones.dart';
import 'package:go_hoard_yourself/src/models/banner.dart';
import 'package:go_hoard_yourself/src/models/building.dart';
import 'package:go_hoard_yourself/src/models/log.dart';
import 'package:go_hoard_yourself/src/models/popup.dart';
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
  List<Task> unlockedTasks = [TASK_GATHER];
  List<Building> unlockedBuildings = [];
  List<Banner> unlockedBanners = BANNERS;
  List<Upgrade> unlockableUpgrades = [];
  List<Upgrade> unlockedUpgrades = [];
  List<LogEntry> log = [];
  int gold = 0;
  int sciencePoints = 0;
  List<Popup> popupQueue = [];

  bool foodUnlocked = false;
  bool koboldsUnlocked = false;
  bool goldUnlocked = false;
  bool scienceUnlocked = false;
  bool overfullUnlocked = false;

  Map<double, Popup> weightMilestones = Map<double, Popup>.from(WEIGHT_MILESTONES);

  void _init() {
    metabolism.specialMods.add((value) => overfull ? value/2 : value);
    workSpeed.specialMods.add((value) => overfull ? value/2 : value);
  }

  Dragon() {
    _init();
    if (NewGameComponent.INSTANCE != null) {
      NewGameComponent.INSTANCE.showNewGame();
    }
  }

  void onTick() {
    // pop up any milestones
    for (var entry in weightMilestones.entries.toList()) {
      if (weight >= entry.key) {
        showPopup(entry.value);
        weightMilestones.remove(entry.key);
      }
    }

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

    if (overfull && !overfullUnlocked) {
      overfullUnlocked = true;
      showPopup(Popup('Too much to eat...', '''
        As you chow down on your latest meal, your stomach begins to hurt. By the end of it, you're slowly cramming food in your face, groaning in between bites... Your poor gut couldn't hold another scrap! With a sick-sounding hiccup, you go back to your den to rest it off...

        (You have just eaten too much and became overfull. While overfull, your work speed and digestion rate is reduced. To eat as much as you want, try to avoid becoming overfull!)
      '''));
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
      'overfull': overfullUnlocked,
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
    gold = json['gold'] ?? 0;
    sciencePoints = json['sciencePoints'] ?? 0;
    koboldsUnlocked = json['unlocked']['kobolds'] ?? false;
    goldUnlocked = json['unlocked']['gold'] ?? false;
    scienceUnlocked = json['unlocked']['science'] ?? false;
    foodUnlocked = json['unlocked']['food'] ?? false;
    overfullUnlocked = json['unlocked']['overfull'] ?? false;

    for (var building in unlockedBuildings) {
      for (var i = 0; i < building.owned; i++) {
        building.onBought(this);
      }
    }
    for (var upgrade in unlockedUpgrades) {
      upgrade.onUnlock(this);
    }

    for (var entry in weightMilestones.entries.toList()) {
      if (weight >= entry.key) {
        weightMilestones.remove(entry.key);
      }
    }
  }

  void save() {
    window.localStorage['GHY_Savegame'] = jsonEncode(toJSON());
  }

  factory Dragon.load() {
    if (window.localStorage.containsKey('GHY_Savegame')) {
      return Dragon.fromJSON(jsonDecode(window.localStorage['GHY_Savegame']));
    } else {
      return Dragon();
    }
  }

  void showPopup(Popup popup) {
    popupQueue.add(popup);
    if (PopupComponent.INSTANCE != null && !PopupComponent.INSTANCE.open) {
      PopupComponent.INSTANCE.showPopup();
    }
  }
}
