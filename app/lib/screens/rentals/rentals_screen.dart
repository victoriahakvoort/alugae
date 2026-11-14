import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

class RentalsScreen extends StatelessWidget {
  const RentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      title: AppStrings.rentals,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(AppRoutes.rentalForm),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
