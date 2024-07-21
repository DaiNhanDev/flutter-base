import 'package:flutter/material.dart';

import '../../constants/app_context.dart';
import '../../constants/strings.dart';
import '../../global/localization.dart';
import '../../models/badge_type.dart';
import '../account/account_screen.dart';
import '../home/home_screen.dart';
import '../landing/landing_screen.dart';
import '../options/options_screen.dart';
import '../splash/splash_screen.dart';
import 'tabbar_icon.dart';

enum BottomTabbar { home, options, account }

typedef OnNavigateToTab = void Function(BottomTabbar tab,
    {Map<String, dynamic> params});

List<BottomTabbar> get allTabbarItems => [
      BottomTabbar.home,
      BottomTabbar.options,
      BottomTabbar.account,
    ];

BottomTabbar bottomBarFromIndex(int index) {
  return BottomTabbar.values[index];
}

extension BottomTabbarExtension on BottomTabbar {
  Widget toScreen({OnNavigateToTab? onNavigateToTab}) {
    switch (this) {
      case BottomTabbar.home:
        return const HomeScreen();
      case BottomTabbar.options:
        return const OptionsScreen();
      case BottomTabbar.account:
        return const AccountScreen();
    }
  }

  BadgeType? toBadgeType() {
    switch (this) {
      case BottomTabbar.options:
        return BadgeType.tabbarOptions;
      default:
        break;
    }
    return null;
  }

  String toTitle() {
    switch (this) {
      case BottomTabbar.home:
        return Strings.Dashboard.tabbarHome;
      case BottomTabbar.options:
        return Strings.Dashboard.tabbarOptions;
      case BottomTabbar.account:
        return Strings.Dashboard.tabbarAccount;
    }
  }

  IconData _toIcon() {
    switch (this) {
      case BottomTabbar.home:
        return Icons.home;
      case BottomTabbar.options:
        return Icons.settings;
      case BottomTabbar.account:
        return Icons.account_box;
    }
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context) {
    final badgeType = toBadgeType();

    return BottomNavigationBarItem(
      icon: TabbarIcon(
        icon: Icon(
          _toIcon(),
          size: 22,
          color: context.iconColor,
        ),
        badgeType: badgeType,
      ),
      activeIcon: TabbarIcon(
        icon: Icon(
          _toIcon(),
          size: 22,
          color: context.iconColor,
        ),
        badgeType: badgeType,
      ),
      label: S.of(context).translate(toTitle()),
    );
  }
}
