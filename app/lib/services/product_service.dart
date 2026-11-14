import 'package:flutter/foundation.dart';

import '../models/product.dart';
import 'api_client.dart';

/// CRUD de produtos na API.
///
/// É um [ChangeNotifier]: depois de cadastrar, editar ou excluir, avisa as
/// telas que estão ouvindo, para elas recarregarem os dados.
class ProductService extends ChangeNotifier {
  ProductService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  /// Instância compartilhada pelas telas de produtos.
  static final ProductService instance = ProductService();

  final ApiClient _client;

  Future<List<Product>> list() async {
    final List<dynamic> data = await _client.get('/products') as List<dynamic>;

    return data
        .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> find(int id) async {
    final dynamic data = await _client.get('/products/$id');
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<Product> create(Product product) async {
    final dynamic data = await _client.post('/products', product.toJson());
    notifyListeners();
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<Product> update(Product product) async {
    final dynamic data = await _client.put(
      '/products/${product.id}',
      product.toJson(),
    );
    notifyListeners();
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _client.delete('/products/$id');
    notifyListeners();
  }
}
