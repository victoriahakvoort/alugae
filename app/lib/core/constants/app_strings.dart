/// Textos exibidos no app.
abstract final class AppStrings {
  static const String appName = 'Alugaê';
  static const String slogan = 'Gestão de locações de forma simples';

  // Abas
  static const String tabHome = 'Início';
  static const String tabProducts = 'Produtos';
  static const String tabRentals = 'Locações';

  // Títulos das telas
  static const String signIn = 'Entrar';
  static const String products = 'Produtos';
  static const String newProduct = 'Novo produto';
  static const String editProduct = 'Editar produto';
  static const String productDetails = 'Detalhes do produto';
  static const String rentals = 'Locações';
  static const String newRental = 'Nova locação';

  // Login
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String signOut = 'Sair';
  static const String welcome = 'Olá';

  // Validações
  static const String validationRequired = 'Campo obrigatório';
  static const String validationEmail = 'Informe um e-mail válido';

  // Erros
  static const String errorConnection =
      'Não foi possível conectar à API. Confira se ela está rodando.';
  static const String errorTimeout =
      'A API demorou para responder. Tente novamente.';
  static const String errorGeneric = 'Algo deu errado. Tente novamente.';
  static const String errorUnauthorized =
      'Sua sessão expirou. Entre novamente.';

  // Gerais
  static const String underConstruction = 'Em construção';
  static const String routeNotFound = 'Rota não encontrada';
}
