import '../constants/app_strings.dart';
import 'formatters.dart';

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

  /// Número inteiro, zero ou maior (ex.: estoque).
  static String? nonNegativeInt(String? value) {
    final String? error = requiredField(value);
    if (error != null) return error;

    final int? number = int.tryParse(value!.trim());
    if (number == null) return AppStrings.validationInteger;
    if (number < 0) return AppStrings.validationNonNegative;
    return null;
  }

  /// Número com decimais, zero ou maior (ex.: valor da diária).
  static String? nonNegativeDecimal(String? value) {
    final String? error = requiredField(value);
    if (error != null) return error;

    final double? number = Formatters.parseDecimal(value!);
    if (number == null) return AppStrings.validationNumber;
    if (number < 0) return AppStrings.validationNonNegative;
    return null;
  }
}
