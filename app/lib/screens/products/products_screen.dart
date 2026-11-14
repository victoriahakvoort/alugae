import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      title: AppStrings.products,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(AppRoutes.productForm),
        child: const Icon(Icons.add_rounded),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => context.goNamed(
            AppRoutes.productDetails,
            pathParameters: <String, String>{'id': '1'},
          ),
          child: const Text(AppStrings.productDetails),
        ),
      ],
    );
  }
}
