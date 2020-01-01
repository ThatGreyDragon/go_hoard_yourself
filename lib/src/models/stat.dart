typedef double StatMod();
typedef double SpecialStatMod(double value);

class Stat {
  double base;
  List<StatMod> flatMods = [];
  List<StatMod> percentMods = [];
  List<SpecialStatMod> specialMods = [];

  Stat(this.base);

  double get value {
      var result = flatMods.fold(base, (total, mod) => total + mod());
      result *= percentMods.fold(1.0, (total, mod) => total + mod());
      return specialMods.fold(result, (total, mod) => mod(total));
  }
}
