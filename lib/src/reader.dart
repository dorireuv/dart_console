import 'dart:io';

import 'package:dart_guava/dart_guava.dart';

import 'key.dart';
import 'stdin/stdin_helper.dart';

class Reader {
  int readByteSync({bool echo = true}) {
    if (echo) {
      return stdin.readByteSync();
    } else {
      return StdinHelper.runSyncWithoutEcho(stdin.readByteSync);
    }
  }

  Key readKey() {
    return StdinHelper.runSyncWithoutEcho(() {
      int charCode = readByteSync();
      final isControlSequence = charCode == CharCodes.esc;
      return isControlSequence
          ? _handleControlSequence()
          : _handleSingleCharCode(charCode);
    });
  }

  static Key _handleSingleCharCode(int charCode) {
    return Key.charCode(charCode);
  }

  static Key _handleControlSequence() {
    final charCode = stdin.readByteSync();
    final isControlSequenceIntroducer = charCode == 0x5B;

    if (!isControlSequenceIntroducer) {
      return Key.control(ControlCharacter.unknown);
    }

    final controlSequenceCharCode = stdin.readByteSync();
    return Key.control(
        ControlCharacter.fromControlSequenceCharCode(controlSequenceCharCode));
  }
}
