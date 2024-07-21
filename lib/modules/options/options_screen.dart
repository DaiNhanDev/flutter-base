import 'package:flutter/material.dart';

import '../../widgets/text/x_text.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: XText.displayMedium('Options'),
    );
  }
}
