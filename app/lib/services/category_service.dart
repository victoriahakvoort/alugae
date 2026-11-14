import '../models/category.dart';
import 'api_client.dart';

/// Leitura das categorias, usada no formulário de produto.
class CategoryService {
  CategoryService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<List<Category>> list() async {
    final List<dynamic> data =
        await _client.get('/categories') as List<dynamic>;

    return data
        .map((dynamic item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
