import 'package:flutter/material.dart';

import '../../widgets/text/x_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: XText.displayMedium('Home'),
    );
  }
}
