import 'package:dart_console/dart_console.dart';
import 'package:dart_guava/dart_guava.dart';
import 'package:test/test.dart';

void main() {
  test('controlCharacter', () {
    expect(Key.charCode(CharCodes.lf).controlCharacter, ControlCharacter.enter);
  });
}
