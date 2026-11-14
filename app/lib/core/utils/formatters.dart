import 'package:intl/intl.dart';

/// Formatações de valores para exibir e para ler dos campos.
abstract final class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  /// 150.0 → "R$ 150,00"
  static String currency(double value) => _currency.format(value);

  /// "150,50" ou "150.50" → 150.5 (ou null, se não for número).
  static double? parseDecimal(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  /// 150.5 → "150,50", para preencher o campo na edição.
  static String decimalInput(double value) =>
      value.toStringAsFixed(2).replaceAll('.', ',');
}
