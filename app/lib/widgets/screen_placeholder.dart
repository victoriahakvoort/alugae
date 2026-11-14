import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Tela provisória, usada enquanto o conteúdo de uma rota não existe.
class ScreenPlaceholder extends StatelessWidget {
  const ScreenPlaceholder({
    required this.title,
    this.actions = const <Widget>[],
    this.floatingActionButton,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: floatingActionButton,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                AppStrings.underConstruction,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.md),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
