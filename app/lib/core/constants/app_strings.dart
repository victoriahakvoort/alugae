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

  // Produtos
  static const String productsEmpty = 'Nenhum produto cadastrado ainda.';
  static const String name = 'Nome';
  static const String description = 'Descrição';
  static const String category = 'Categoria';
  static const String stock = 'Estoque';
  static const String dailyPrice = 'Valor da diária (R\$)';
  static const String status = 'Situação';
  static const String active = 'Ativo';
  static const String inactive = 'Inativo';
  static const String units = 'unidades';
  static const String noDescription = 'Sem descrição';
  static const String noValue = '—';
  static const String separator = ' · ';

  // Ações
  static const String save = 'Salvar';
  static const String edit = 'Editar';
  static const String delete = 'Excluir';
  static const String cancel = 'Cancelar';
  static const String tryAgain = 'Tentar novamente';

  // Mensagens de produtos
  static const String productSaved = 'Produto salvo com sucesso.';
  static const String productDeleted = 'Produto excluído.';
  static const String deleteProductTitle = 'Excluir produto?';
  static const String deleteProductMessage = 'Essa ação não pode ser desfeita.';

  // Validações numéricas
  static const String validationInteger = 'Informe um número inteiro';
  static const String validationNumber =
      'Informe um valor válido (ex.: 150,00)';
  static const String validationNonNegative = 'O valor não pode ser negativo';
}
