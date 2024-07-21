import '../../global/app_analytics.dart';
import '../../models/authorization.dart';
import '../../models/user.dart';
import '../../utils/device.dart';

mixin Analytics {
  void logLogIn({
    required User loggedInUser,
    Authorization? authorization,
  }) {
    final deviceType = Device.getDeviceType() == 1 ? 'android' : 'ios';
    AppAnalytics().logLogIn(
      name: loggedInUser.name,
      deviceType: deviceType,
    );
  }
}
