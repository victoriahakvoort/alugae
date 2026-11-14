import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../widgets/screen_placeholder.dart';

/// Formulário de produto. Sem [productId], cadastra; com ele, edita.
class ProductFormScreen extends StatelessWidget {
  const ProductFormScreen({this.productId, super.key});

  final int? productId;

  bool get isEditing => productId != null;

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      title: isEditing ? AppStrings.editProduct : AppStrings.newProduct,
    );
  }
}
