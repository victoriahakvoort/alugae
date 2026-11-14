/// Categoria de produto (Painéis, Mesas…), como a API devolve.
class Category {
  const Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, name: json['name'] as String);
  }

  final int id;
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};
}
