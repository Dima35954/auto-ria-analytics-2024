import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class CheckWidgetPresent extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I should see the widget {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);
    if (!isPresent) {
      throw Exception('Widget with key $key not found');
    }
  }
}

class TapButton extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I tap the {string} button");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, locator);
  }
}