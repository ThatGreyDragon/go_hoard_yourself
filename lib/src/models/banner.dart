import 'package:go_hoard_yourself/src/models/dragon.dart';

typedef String BannerGenerator(Dragon dragon);

class Banner {
  BannerGenerator generate;
  Banner(this.generate);
}
