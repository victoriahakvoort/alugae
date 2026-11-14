/// Caminhos e nomes das rotas do app.
///
/// Nunca escreva o caminho como string literal ao navegar: use
/// `context.goNamed(AppRoutes.products)`. Assim, renomear uma rota é uma
/// mudança em um arquivo só.
abstract final class AppRoutes {
  // Autenticação
  static const String signIn = 'sign-in';
  static const String signInPath = '/login';

  // Abas principais (dentro do shell com bottom navigation)
  static const String home = 'home';
  static const String homePath = '/inicio';

  static const String products = 'products';
  static const String productsPath = '/produtos';

  static const String rentals = 'rentals';
  static const String rentalsPath = '/locacoes';

  // Rotas filhas de produtos (abrem por cima das abas)
  static const String productForm = 'product-form';
  static const String productFormPath = 'novo';

  static const String productDetails = 'product-details';
  static const String productDetailsPath = ':id';

  static const String productEdit = 'product-edit';
  static const String productEditPath = 'editar';

  // Rotas filhas de locações
  static const String rentalForm = 'rental-form';
  static const String rentalFormPath = 'nova';
}
