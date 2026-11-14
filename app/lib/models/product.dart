import 'category.dart';

/// Produto disponível para locação.
///
/// O [id] é nulo enquanto o produto ainda não foi salvo na API.
class Product {
  const Product({
    required this.name,
    required this.categoryId,
    required this.stock,
    required this.dailyPrice,
    this.id,
    this.description,
    this.category,
    this.image,
    this.enabled = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dynamic categoryJson = json['category'];

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      categoryId: json['category_id'] as int,
      category: categoryJson is Map<String, dynamic>
          ? Category.fromJson(categoryJson)
          : null,
      stock: json['stock'] as int,
      // A API manda o preço como texto ("150.00") por causa do cast decimal:2.
      dailyPrice: double.parse(json['daily_price'].toString()),
      image: json['image'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  final int? id;
  final String name;
  final String? description;
  final int categoryId;
  final Category? category;
  final int stock;
  final double dailyPrice;
  final String? image;
  final bool enabled;

  /// Dados enviados à API no cadastro e na edição.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'description': description,
    'category_id': categoryId,
    'stock': stock,
    'daily_price': dailyPrice,
    'enabled': enabled,
  };
}
