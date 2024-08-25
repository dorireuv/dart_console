import 'dart:io';

import 'package:dart_ansi/dart_ansi.dart';
import 'package:dart_guava/dart_guava.dart';

import 'key.dart';
import 'question_asker.dart';
import 'reader.dart';

/// A facade for interacting with the console.
class Console {
  final Reader _reader;
  late final QuestionAsker _questionAsker = QuestionAsker(reader: _reader);

  Console({Reader? reader}) : _reader = reader ?? Reader();

  void clearScreenAndMoveCursorHome() {
    stdout.write(AnsiSequences.clearScreen);
    stdout.write(AnsiSequences.moveCursorHome);
  }

  void clearLineAndReturnCursor() =>
      stdout.write(AnsiSequences.eraseLineAndReturnCursor);

  void print(Object? object) => stdout.write(object);

  void println(Object? object) => stdout.writeln(object);

  Key? readKey() => _reader.readKey();

  void waitUntilKeyPress() => _reader.readByteSync(echo: false);

  Future<int> askRequiredInt({
    required Object prompt,
    int? defaultValue,
    IntRange? validRange,
  }) async {
    return (await _questionAsker.askInt(
      question: prompt,
      defaultValue: defaultValue,
      isRequired: true,
      validRange: validRange,
    ))!;
  }

  Future<int?> askOptionalInt({
    required Object prompt,
    int? defaultValue,
    IntRange? validRange,
  }) {
    return _questionAsker.askInt(
        question: prompt,
        defaultValue: defaultValue,
        isRequired: false,
        validRange: validRange);
  }
}
