import 'dart:io';

final class StdinHelper {
  StdinHelper._();

  static T runSyncWithoutEcho<T>(T Function() f) {
    try {
      _disableEchoMode();
      return f();
    } finally {
      _enableEchoMode();
    }
  }

  static Future<T> runAsyncWithoutEcho<T>(Future<T> Function() f) async {
    try {
      _disableEchoMode();
      return await f();
    } finally {
      _enableEchoMode();
    }
  }

  static void _disableEchoMode() => _setEchoMode(false);

  static void _enableEchoMode() => _setEchoMode(true);

  static void _setEchoMode(bool echoMode) {
    stdin.echoMode = echoMode;
    stdin.lineMode = echoMode;
  }
}
