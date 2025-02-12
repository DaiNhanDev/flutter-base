import 'package:flutter/material.dart';

import '../../constants/app_context.dart';
import '../../constants/app_texts.dart';
import '../text/x_text.dart';

class XLinkButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String? title;
  final Widget? child;
  final String? prefixIconPath;
  final List<Shadow>? shadow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final double? fontSize;

  const XLinkButton({
    super.key,
    this.onPressed,
    this.title,
    this.child,
    this.prefixIconPath,
    this.shadow,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: child ??
          XText.custom(
            title ?? '',
            style: TextStyleEnum.bodySmall.getTextStyle(context)?.copyWith(
                  shadows: shadow ??
                      [
                        Shadow(
                          color: context.primaryColor,
                          offset: const Offset(0, -2),
                        )
                      ],
                  color: Colors.transparent,
                  decoration: decoration ?? TextDecoration.none,
                  decorationColor: decorationColor ?? context.primaryColor,
                  decorationThickness: decorationThickness ?? 1.0,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
          ),
    );
  }
}
