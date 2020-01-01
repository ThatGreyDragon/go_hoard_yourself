abstract class Food {
  String get name;
  String get desc;
  double get eatTime;
  double get size;
  double get fatRatio;
  double get digestionRate;
}

class BasicFood extends Food {
  @override
  String name, desc;

  @override
  double eatTime, size, fatRatio, digestionRate;

  BasicFood({this.name, this.desc, this.eatTime, this.size, this.fatRatio, this.digestionRate});
}
