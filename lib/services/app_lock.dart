import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Device authentication (fingerprint / face / PIN) and the "secure window" flag.
class AppLockService {
  final _auth = LocalAuthentication();
  static const _secure = MethodChannel('tempo/secure');

  /// True if the phone has a screen lock or biometrics we can use.
  Future<bool> available() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } catch (_) {
      return false;
    }
  }

  /// Hide content in recent apps and block screenshots while [on].
  Future<void> setSecure(bool on) async {
    try {
      await _secure.invokeMethod('setSecure', on);
    } catch (_) {
      // Not available (tests, other platforms).
    }
  }
}
