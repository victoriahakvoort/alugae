/// Erro vindo da API, já com uma mensagem pronta para a tela.
class ApiException implements Exception {
  ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  final String message;
  final int? statusCode;

  /// Erros de validação (422), por campo: `{'name': 'The name field is required.'}`.
  final Map<String, String> fieldErrors;

  @override
  String toString() => message;
}
