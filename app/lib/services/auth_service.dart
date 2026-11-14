import 'package:flutter/foundation.dart';

import '../models/user.dart';
import 'api_client.dart';

/// Sessão do usuário: login, logout e quem está logado.
///
/// É um [ChangeNotifier]: quando o login muda, avisa quem estiver
/// ouvindo (o router usa isso para redirecionar).
class AuthService extends ChangeNotifier {
  AuthService._(this._client) {
    _client.onUnauthorized = _handleUnauthorized;
  }

  static final AuthService instance = AuthService._(ApiClient.instance);

  final ApiClient _client;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  /// Ao abrir o app: se há um token salvo, confirma com a API quem é o usuário.
  Future<void> restoreSession() async {
    await _client.loadToken();
    if (!_client.hasToken) return;

    try {
      final dynamic data = await _client.get('/me');
      _currentUser = User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      await _client.clearToken();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final dynamic data = await _client.post('/login', <String, dynamic>{
      'email': email,
      'password': password,
    });

    final Map<String, dynamic> json = data as Map<String, dynamic>;
    await _client.saveToken(json['token'] as String);
    _currentUser = User.fromJson(json['user'] as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _client.post('/logout');
    } on ApiException {
      // Mesmo se a API não responder, a sessão é encerrada no app.
    }
    await _client.clearToken();
    _currentUser = null;
    notifyListeners();
  }

  void _handleUnauthorized() {
    _currentUser = null;
    notifyListeners();
  }
}
