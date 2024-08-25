import 'package:dart_guava/dart_guava.dart';

/// Non printable control characters.
enum ControlCharacter {
  arrowLeft,
  arrowRight,
  arrowUp,
  arrowDown,
  enter,
  unknown,
  ;

  static ControlCharacter fromCharCode(int charCode) {
    switch (charCode) {
      case CharCodes.lf:
        return ControlCharacter.enter;

      default:
        return ControlCharacter.unknown;
    }
  }

  static ControlCharacter fromControlSequenceCharCode(int charCode) {
    switch (charCode) {
      case 0x41:
        return ControlCharacter.arrowUp;
      case 0x42:
        return ControlCharacter.arrowDown;
      case 0x43:
        return ControlCharacter.arrowRight;
      case 0x44:
        return ControlCharacter.arrowLeft;
      default:
        return ControlCharacter.unknown;
    }
  }
}

final class Key {
  final int? _charCode;
  final ControlCharacter? _controlCharacter;

  static Key charCode(int charCode) =>
      Key._(charCode: charCode, controlCharacter: null);

  static Key control(ControlCharacter controlCharacter) =>
      Key._(charCode: null, controlCharacter: controlCharacter);

  Key._({required int? charCode, required ControlCharacter? controlCharacter})
      : _charCode = charCode,
        _controlCharacter = controlCharacter {
    checkArgument((charCode == null) != (controlCharacter == null));
  }

  ControlCharacter? get controlCharacter {
    final controlCharacter = _controlCharacter;
    if (controlCharacter != null) {
      return controlCharacter;
    }

    final charCode = _charCode;
    if (charCode != null && CharCodes.isControlCharacter(charCode)) {
      return ControlCharacter.fromCharCode(charCode);
    }

    return null;
  }

  String? get printableChar {
    final charCode = _charCode;
    if (charCode != null && CharCodes.isPrintable(charCode)) {
      return String.fromCharCode(charCode);
    }

    return null;
  }

  @override
  String toString() {
    final charCode = _charCode;
    if (charCode != null) {
      return CharCodes.isPrintable(charCode)
          ? String.fromCharCode(charCode)
          : 'Key[charCode=$charCode]';
    }

    final controlCharacter = _controlCharacter;
    if (controlCharacter != null) {
      return controlCharacter.toString();
    }

    throw AssertionError('Unreachable code');
  }
}
