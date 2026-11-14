import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/product_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final int productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductService _service = ProductService.instance;
  late Future<Product> _future;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _future = _service.find(widget.productId);
    _service.addListener(_reload);
  }

  @override
  void dispose() {
    _service.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    // Depois de excluir, o produto não existe mais: não há o que recarregar.
    if (_deleting) return;
    setState(() => _future = _service.find(widget.productId));
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteProductTitle),
        content: const Text(AppStrings.deleteProductMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    setState(() => _deleting = true);

    try {
      await _service.delete(widget.productId);
      if (!mounted) return;
      context.goNamed(AppRoutes.products);
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.productDeleted)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetails),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: _deleting
                ? null
                : () => context.goNamed(
                    AppRoutes.productEdit,
                    pathParameters: <String, String>{
                      'id': '${widget.productId}',
                    },
                  ),
          ),
          IconButton(
            tooltip: AppStrings.delete,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _deleting ? null : _confirmDelete,
          ),
        ],
      ),
      body: FutureBuilder<Product>(
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

          final Product product = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Text(product.name, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xs),
              Text(
                product.enabled ? AppStrings.active : AppStrings.inactive,
                style: AppTextStyles.body.copyWith(
                  color: product.enabled ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Column(
                  children: <Widget>[
                    _DetailTile(
                      label: AppStrings.category,
                      value: product.category?.name ?? AppStrings.noValue,
                    ),
                    _DetailTile(
                      label: AppStrings.dailyPrice,
                      value: Formatters.currency(product.dailyPrice),
                    ),
                    _DetailTile(
                      label: AppStrings.stock,
                      value: '${product.stock} ${AppStrings.units}',
                    ),
                    _DetailTile(
                      label: AppStrings.description,
                      value: product.description ?? AppStrings.noDescription,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Uma linha "rótulo / valor" dos detalhes.
class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTextStyles.body),
      subtitle: Text(value, style: AppTextStyles.subtitle),
    );
  }
}
