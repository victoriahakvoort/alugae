import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

/// Formulário de produto. Sem [productId], cadastra; com ele, edita.
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({this.productId, super.key});

  final int? productId;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ProductService _productService = ProductService.instance;
  final CategoryService _categoryService = CategoryService();

  late Future<List<Category>> _loading;
  int? _categoryId;
  bool _enabled = true;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _loading = _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  /// Busca as categorias e, na edição, preenche os campos com o produto.
  Future<List<Category>> _load() async {
    final List<Category> categories = await _categoryService.list();

    if (_isEditing) {
      final Product product = await _productService.find(widget.productId!);
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _stockController.text = '${product.stock}';
      _priceController.text = Formatters.decimalInput(product.dailyPrice);
      _categoryId = product.categoryId;
      _enabled = product.enabled;
    }

    return categories;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    final String description = _descriptionController.text.trim();
    final Product product = Product(
      id: widget.productId,
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      categoryId: _categoryId!,
      stock: int.parse(_stockController.text.trim()),
      dailyPrice: Formatters.parseDecimal(_priceController.text)!,
      enabled: _enabled,
    );

    try {
      if (_isEditing) {
        await _productService.update(product);
      } else {
        await _productService.create(product);
      }

      if (!mounted) return;
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      if (_isEditing) {
        context.goNamed(
          AppRoutes.productDetails,
          pathParameters: <String, String>{'id': '${widget.productId}'},
        );
      } else {
        context.goNamed(AppRoutes.products);
      }

      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.productSaved)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppStrings.editProduct : AppStrings.newProduct,
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: _loading,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: () => setState(() => _loading = _load()),
            );
          }

          return _buildForm(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildForm(List<Category> categories) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            enabled: !_saving,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: AppStrings.name),
            validator: Validators.requiredField,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: AppStrings.category),
            items: categories
                .map(
                  (Category category) => DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                )
                .toList(),
            onChanged: _saving
                ? null
                : (int? value) => setState(() => _categoryId = value),
            validator: (int? value) =>
                value == null ? AppStrings.validationRequired : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  enabled: !_saving,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: AppStrings.stock,
                  ),
                  validator: Validators.nonNegativeInt,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: AppStrings.dailyPrice,
                  ),
                  validator: Validators.nonNegativeDecimal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _descriptionController,
            enabled: !_saving,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: AppStrings.description,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            value: _enabled,
            contentPadding: EdgeInsets.zero,
            title: const Text(AppStrings.active),
            onChanged: _saving
                ? null
                : (bool value) => setState(() => _enabled = value),
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: AppSpacing.loaderSize,
                    width: AppSpacing.loaderSize,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}
