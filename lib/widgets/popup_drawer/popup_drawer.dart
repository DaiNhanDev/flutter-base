import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../animated/bounce/animated_bounce.dart';
import '../animated/floating/animated_floating.dart';
import '../app_icon/app_icon.dart';
import 'alert/alert.dart';
import 'base_popup_drawer.dart';
import 'confirmation/confirmation.dart';

class PopupDrawer {
  final BuildContext context;

  PopupDrawer.of(this.context);

  BasePopupDrawer confirmation({
    Key? key,
    required String title,
    required String message,
    String? okTitle,
    String? cancelTitle,
    AppIcon? icon,
  }) {
    return BasePopupDrawer(
      context: context,
      key: key,
      child: Confirmation(
        title: title,
        message: message,
        okTitle: okTitle,
        cancelTitle: cancelTitle,
        icon: icon,
      ),
    );
  }

  BasePopupDrawer alert({
    Key? key,
    required String title,
    required String message,
    String? okTitle,
    AppIcon? icon,
    bool animation = true,
  }) {
    return BasePopupDrawer(
      context: context,
      key: key,
      child: Alert(
        title: title,
        message: message,
        okTitle: okTitle,
        icon: icon,
      ),
    );
  }

  BasePopupDrawer open({
    Key? key,
    required Widget widget,
    Color? backgroundColor,
    bool animation = true,
  }) {
    final dialog = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      content: widget,
    );

    return BasePopupDrawer(
      context: context,
      key: key,
      child: animation
          ? AnimatedBounce(
              child: dialog,
            )
          : dialog,
    );
  }

  BasePopupDrawer actionSheet({
    Key? key,
    required Widget widget,
    double height = AppConstants.mDefaultActionSheetHeight,
    bool animation = true,
  }) {
    final dialog = AlertDialog(
      contentPadding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      insetPadding: const EdgeInsets.all(0),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: widget,
      ),
    );

    return BasePopupDrawer(
      context: context,
      key: key,
      child: animation
          ? AnimatedFloating(
              child: dialog,
            )
          : dialog,
    );
  }
}
