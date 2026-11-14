import '../constants/app_strings.dart';

/// Validações dos campos de formulário.
///
/// Cada método segue o formato que o `TextFormField` espera:
/// devolve `null` se o valor está certo, ou a mensagem de erro.
abstract final class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  static String? email(String? value) {
    final String? error = requiredField(value);
    if (error != null) return error;

    final bool valid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(value!.trim());
    return valid ? null : AppStrings.validationEmail;
  }
}
