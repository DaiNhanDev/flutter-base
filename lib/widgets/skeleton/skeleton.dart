import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

class Skeleton extends StatelessWidget {
  final Widget child;
  const Skeleton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  factory Skeleton.standard({required Widget child}) {
    return Skeleton(
      child: Shimmer.fromColors(
        baseColor: AppColors.dark.withOpacity(0.08),
        highlightColor: AppColors.dark.withOpacity(0.2),
        period: const Duration(milliseconds: 2000),
        child: child,
      ),
    );
  }

  factory Skeleton.standardDark({required Widget child}) {
    return Skeleton(
      child: Shimmer.fromColors(
        baseColor: AppColors.white,
        highlightColor: Colors.white70,
        period: const Duration(milliseconds: 2000),
        child: child,
      ),
    );
  }
}
