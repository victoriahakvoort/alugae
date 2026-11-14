import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/sign_in_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/products/product_details_screen.dart';
import '../../screens/products/product_form_screen.dart';
import '../../screens/products/products_screen.dart';
import '../../screens/rentals/rental_form_screen.dart';
import '../../screens/rentals/rentals_screen.dart';
import '../../screens/shell/app_shell.dart';
import '../../services/auth_service.dart';
import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import 'app_routes.dart';

/// Configuração de navegação do app.
///
/// ```
/// /login                           → entrar
/// ┌ shell com bottom nav ──────────────────────┐
/// │ /inicio                    → resumo        │
/// │ /produtos                  → lista         │
/// │   ├ /produtos/novo         → formulário    │
/// │   └ /produtos/:id          → detalhes      │
/// │       └ /produtos/:id/editar → formulário  │
/// │ /locacoes                  → lista         │
/// │   └ /locacoes/nova         → formulário    │
/// └────────────────────────────────────────────┘
/// ```
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.signInPath,
    debugLogDiagnostics: true,
    refreshListenable: AuthService.instance,
    redirect: (context, state) {
      final bool signedIn = AuthService.instance.isSignedIn;
      final bool goingToSignIn = state.matchedLocation == AppRoutes.signInPath;

      if (!signedIn && !goingToSignIn) return AppRoutes.signInPath;
      if (signedIn && goingToSignIn) return AppRoutes.homePath;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.signInPath,
        name: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.productsPath,
                name: AppRoutes.products,
                builder: (context, state) => const ProductsScreen(),
                routes: <RouteBase>[
                  // "novo" vem antes de ":id", senão a palavra "novo"
                  // seria lida como um id.
                  GoRoute(
                    path: AppRoutes.productFormPath,
                    name: AppRoutes.productForm,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProductFormScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.productDetailsPath,
                    name: AppRoutes.productDetails,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        ProductDetailsScreen(productId: _idFrom(state)),
                    routes: <RouteBase>[
                      GoRoute(
                        path: AppRoutes.productEditPath,
                        name: AppRoutes.productEdit,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            ProductFormScreen(productId: _idFrom(state)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.rentalsPath,
                name: AppRoutes.rentals,
                builder: (context, state) => const RentalsScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: AppRoutes.rentalFormPath,
                    name: AppRoutes.rentalForm,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const RentalFormScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            '${AppStrings.routeNotFound}:\n${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  /// Lê o `:id` do caminho como número.
  static int _idFrom(GoRouterState state) =>
      int.parse(state.pathParameters['id']!);
}
