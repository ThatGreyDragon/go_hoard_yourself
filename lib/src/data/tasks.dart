import 'dart:math';

import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/models/log.dart';
import 'package:go_hoard_yourself/src/models/popup.dart';
import 'package:go_hoard_yourself/src/util.dart';

import '../models/task.dart';
import '../models/dragon.dart';
import '../data/foods.dart';

class TaskGather extends Task {
  Random rng = Random();

  @override
  String get id => 'gather';

  @override
  String get name => 'Gather';

  @override
  String get desc => 'Forage and hunt for something to eat!';

  @override
  double get timeToComplete => 10.0;

  @override
  void onComplete(Dragon dragon) {
    dragon.giveFood([
      Weight(5, FOOD_RABBIT),
      Weight(1, FOOD_DEER),
    ].pickWeighted(rng));
    dragon.foodUnlocked = true;

    if (dragon.workingOn == this) {
      dragon.log.add(LogEntry('Afer a long hunt, you catch some prey! Time to dig in...'));
    }

    if (timesCompleted == 1) {
      dragon.showPopup(Popup('The thrill of the hunt', '''
The sighting. The stalking. The pouncing. The kill.

Such are the simple pleasures of the hunt. And, to boot, you got something to eat out of it! Time to dig in...

(Completing tasks nets you rewards. In this case, food! Click on an item in the Food tab to start consuming it. But don't eat too much, or you'll get fat...)
      '''));
    }

    if (timesCompleted == 10) {
      const BASE_MESSAGE = '''
One particularly long hunt ends with the prey diving into a cave you haven't seen previously. Maybe it's worth exploring?
      ''';

      dragon.unlockedTasks.add(TASK_EXPLORE_CAVE);
      dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
      dragon.showPopup(Popup('What\'s this?', BASE_MESSAGE + '''

(Sometimes, doing certain actions will unlock new tasks you can work on. You can only work on one task at a time, though, so plan accordingly!)
      '''));
    }
  }

  TaskGather() {
    maxKoboldsAssignable.flatMods.add(() => 5);
  }
}

class TaskExploreCave extends Task {
  @override
  String get id => 'cave';

  @override
  String get name => 'Explore Cave';

  @override
  String get desc => 'Maybe something good to eat is in there?';

  @override
  double get timeToComplete => 20.0;

  Random rng = Random();

  @override
  void onComplete(Dragon dragon) {
    if (!dragon.marketUnlocked && dragon.goldUnlocked && timesCompleted >= 10) {
      const BASE_MESSAGE = '''
Tucked away among some gold coins you find... An old map! You manage to make out the location of a settlement nearby. The map says it's a trading settlement... Time to pay it a visit with your hoard, you think!
      ''';

      dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
      dragon.showPopup(Popup('A use for gold?', BASE_MESSAGE + '''

(Gold can be used at the Market to purchase items and construct buildings, which provide various benefits based on how many you have. Be careful, however: The cost of every item increases every time you purchase one!)
      '''));
      dragon.marketUnlocked = true;
      dragon.unlockedBuildings.add(BUILDING_STOMACH_OIL);
      dragon.unlockedBuildings.add(BUILDING_OLD_BOOK);
      return;
    }

    if (dragon.marketUnlocked && !dragon.unlockedBuildings.contains(BUILDING_HUNTING_SHACK) && timesCompleted >= 20) {
      const BASE_MESSAGE = '''
You find some old papers lying around in the back of a cavern. Inspecting them further, it seems you have a blueprint on your hands... Ones for a simple building! Considering the fact that your local hunting ground is packed to bursting with kobolds now, something to house more would be perfect for your plans...
      ''';

      dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
      dragon.showPopup(Popup('Overpopulation woes... Solved?', BASE_MESSAGE + '''

(Some buildings, like the Hunting Shack, can be built at the Market to increase work capcity for certain tasks. Other blueprints can be found through research or other means.)
      '''));
      dragon.unlockedBuildings.add(BUILDING_HUNTING_SHACK);
      return;
    }

    if (rng.nextBool()) {
      dragon.giveFood(FOOD_KOBOLD);

      if (!dragon.koboldsUnlocked) {
        const BASE_MESSAGE = '''
You find a kobold huddled in the back of the cave. Upon seeing you, they rush to your side, quickly pledging eternal allegiance to you. Sweet!
        ''';

        dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
        dragon.showPopup(Popup('A new friend...', BASE_MESSAGE + '''

(Kobolds can be assigned to complete tasks for you in the Tasks pane. Take this new friend of yours and assign them to a task now!)
        '''));
        dragon.koboldsUnlocked = true;
      } else if (dragon.workingOn == this) {
        dragon.log.add(LogEntry('''
          You find another kobold back in the cave. Great, more workforce!
        '''));
      }
    } else {
      const BASE_MESSAGE = '''
You find some gold coins tucked away in a crevice of the cave. Maybe you can spend these somewhere... But where? Maybe the cave has answers yet.
      ''';

      dragon.gold += rng.nextIntBetween(100, 200);

      if (!dragon.goldUnlocked) {
        dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
        dragon.showPopup(Popup('Riches!', BASE_MESSAGE));
        dragon.goldUnlocked = true;
      } else if (dragon.workingOn == this) {
        dragon.log.add(LogEntry('''
          You find some more gold back in the cave. What to spend it on...
        '''));
      }
    }
  }

  TaskExploreCave() {
    maxKoboldsAssignable.flatMods.add(() => 5);
  }
}

class TaskStudyBooks extends Task {
  @override
  String get desc => '''Pour over the pages of your collection of tomes, discovering facts you might be able to put to use somewhere...''';

  @override
  String get id => 'study-books';

  @override
  String get name => 'Study Old Books';

  @override
  void onComplete(Dragon dragon) {
    dragon.sciencePoints++;

    if (timesCompleted == 1) {
      const BASE_MESSAGE = '''
As you read the first chapter of this long and dry book, you begin to figure out what this whole thing is about. It's a cookbook! It' all about food! Your stomach rumbles as you turn the next page. If you learn enough about it, you can put these recipes to use...
      ''';

      dragon.log.add(LogEntry(BASE_MESSAGE, LogType.GOOD));
      dragon.showPopup(Popup('Scientific progress goes... Yum', BASE_MESSAGE + '''

(Studying your books gains you research points. Spend them in the Research Tab to unlock new technologies for you and your kobolds.)
      '''));
      dragon.scienceUnlocked = true;
    }
  }

  @override
  double get timeToComplete => 30.0;
  
}

final TaskGather TASK_GATHER = TaskGather();
final TaskExploreCave TASK_EXPLORE_CAVE = TaskExploreCave();
final TaskStudyBooks TASK_STUDY_BOOKS = TaskStudyBooks();

final List<Task> TASKS = [
  TASK_GATHER,
  TASK_EXPLORE_CAVE,
  TASK_STUDY_BOOKS,
];
