import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_icons.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.width,
    required this.height,
    this.color,
    required this.icon,
  });

  final AppIcons icon;
  final double width;
  final double height;
  final Color? color;

  factory AppIcon.closeCircle({
    double width = 20,
    double height = 20,
    Color color = const Color.fromRGBO(60, 60, 67, 0.6),
  }) {
    return AppIcon(
      icon: AppIcons.closeCircle,
      width: width,
      height: height,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.toAssetName(),
      width: width,
      height: height,
      // ignore: deprecated_member_use
      color: color,
    );
  }
}
