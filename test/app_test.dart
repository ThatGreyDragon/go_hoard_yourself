@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:go_hoard_yourself/go_hoard_yourself.dart';
import 'package:go_hoard_yourself/go_hoard_yourself.template.dart' as ng;

void main() {
  final testBed =
      NgTestBed.forComponent<GoHoardYourself>(ng.GoHoardYourselfNgFactory);
  NgTestFixture<GoHoardYourself> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('heading', () {
    // TODO
  });
}
