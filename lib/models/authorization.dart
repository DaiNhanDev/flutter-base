import 'entity.dart';

class Authorization extends Entity {
  final String accessToken;
  final String refreshToken;
  final String shopId;
  Authorization(
      {required this.accessToken,
      required this.refreshToken,
      required this.shopId});

  //ignore: prefer_constructors_over_static_methods
  static Authorization fromJson(Map<String, dynamic> json) {
    return Authorization(
        accessToken: json['access_token'],
        refreshToken: json['refreshToken'],
        shopId: json['_id']);
  }

  @override
  List<Object> get props => [accessToken, refreshToken];

  @override
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refreshToken': refreshToken,
        'shopId': shopId
      };
}
