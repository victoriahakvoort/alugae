import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';

/// Item da lista de produtos.
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, super.key});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> details = <String>[
      product.category?.name ?? AppStrings.noValue,
      '${product.stock} ${AppStrings.units}',
      if (!product.enabled) AppStrings.inactive,
    ];

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primaryDark,
          child: Icon(Icons.inventory_2_outlined),
        ),
        title: Text(product.name, style: AppTextStyles.subtitle),
        subtitle: Text(
          details.join(AppStrings.separator),
          style: AppTextStyles.body,
        ),
        trailing: Text(
          Formatters.currency(product.dailyPrice),
          style: AppTextStyles.subtitle,
        ),
      ),
    );
  }
}
