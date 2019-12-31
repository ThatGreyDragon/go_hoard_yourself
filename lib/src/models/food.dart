abstract class Food {
  String get name;
  double get eatTime;
  double get size;
  double get fatRatio;
  double get digestionRate;
}

class BasicFood extends Food {
  @override
  String name;

  @override
  double eatTime, size, fatRatio, digestionRate;

  BasicFood({this.name, this.eatTime, this.size, this.fatRatio, this.digestionRate});
}
