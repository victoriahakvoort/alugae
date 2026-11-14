import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/product_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _service = ProductService.instance;
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.list();
    _service.addListener(_reload);
  }

  @override
  void dispose() {
    _service.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    setState(() => _future = _service.list());
  }

  Future<void> _refresh() async {
    _reload();
    try {
      await _future;
    } on ApiException {
      // O erro já aparece na tela pelo FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.products)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(AppRoutes.productForm),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          final List<Product> products = snapshot.data!;

          if (products.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              message: AppStrings.productsEmpty,
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: products.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final Product product = products[index];

                return ProductCard(
                  product: product,
                  onTap: () => context.goNamed(
                    AppRoutes.productDetails,
                    pathParameters: <String, String>{'id': '${product.id}'},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
