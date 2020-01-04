import 'package:go_hoard_yourself/src/data/banners.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

typedef String BannerGenerator(Dragon dragon);

class Banner {
  String id;
  BannerGenerator generate;

  Banner(this.id, this.generate);
  factory Banner.fromID(String id) => BANNERS.firstWhere((b) => b.id == id, orElse: () => null);
}
