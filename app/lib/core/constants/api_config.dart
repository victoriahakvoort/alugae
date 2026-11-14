import 'package:flutter/foundation.dart';

/// Endereço da API Laravel.
///
/// Cada lugar onde o app roda enxerga o computador de um jeito:
/// - Chrome (web): o navegador está no próprio computador → `localhost`.
/// - Emulador Android: o emulador enxerga o computador como `10.0.2.2`.
/// - Celular físico: trocar pelo IP do computador na rede (ex.: 192.168.0.10).
abstract final class ApiConfig {
  static const String _localhost = 'http://localhost:8000/api';
  static const String _androidEmulator = 'http://10.0.2.2:8000/api';

  static String get baseUrl {
    if (kIsWeb) return _localhost;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulator;
    }
    return _localhost;
  }

  static const Duration timeout = Duration(seconds: 15);
}
