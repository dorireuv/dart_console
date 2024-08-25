import 'dart:convert';
import 'dart:io';

import 'package:dart_ansi/dart_ansi.dart';
import 'package:dart_guava/dart_guava.dart';

import 'reader.dart';
import 'stdin/stdin_helper.dart';

class QuestionAsker {
  final Reader _reader;

  QuestionAsker({Reader? reader}) : _reader = reader ?? Reader();

  Future<int?> askInt({
    required Object question,
    int? defaultValue,
    IntRange? validRange,
    bool isRequired = false,
  }) async {
    int? value;
    do {
      stdout.write(AnsiSequences.eraseLineAndReturnCursor);
      stdout.write(question);
      await stdout.flush();

      value = (await _readInt()) ?? defaultValue;
    } while ((value == null && isRequired) ||
        (value != null && (validRange?.isNotIn(value) ?? false)));

    stdout.writeln();

    return value;
  }

  Future<int?> _readInt() async {
    return StdinHelper.runAsyncWithoutEcho(() async {
      final charCodes = <int>[];
      int charCode;
      do {
        charCode = _reader.readByteSync();
        if (CharCodes.isDigit(charCode)) {
          stdout.writeCharCode(charCode);
          await stdout.flush();
          charCodes.add(charCode);
        } else if (charCode == CharCodes.del) {
          if (charCodes.isNotEmpty) {
            stdout
              ..writeCharCode(CharCodes.bs)
              ..writeCharCode(CharCodes.space)
              ..writeCharCode(CharCodes.bs);
            await stdout.flush();
            charCodes.removeLast();
          }
        }
      } while (charCode != CharCodes.lf && charCode != CharCodes.cr);

      return int.tryParse(utf8.decode(charCodes));
    });
  }
}
