import 'package:flutter/material.dart';

/// Estado de carregamento: um indicador centralizado.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
