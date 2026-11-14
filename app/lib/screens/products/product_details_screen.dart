import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      title: '${AppStrings.productDetails} #$productId',
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => context.goNamed(
            AppRoutes.productEdit,
            pathParameters: <String, String>{'id': '$productId'},
          ),
          child: const Text(AppStrings.editProduct),
        ),
      ],
    );
  }
}
