import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../services/auth_service.dart';
import '../../widgets/screen_placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = AuthService.instance.currentUser?.name ?? '';

    return ScreenPlaceholder(
      title: '${AppStrings.welcome}, $name',
      actions: <Widget>[
        ElevatedButton(
          onPressed: AuthService.instance.signOut,
          child: const Text(AppStrings.signOut),
        ),
      ],
    );
  }
}
