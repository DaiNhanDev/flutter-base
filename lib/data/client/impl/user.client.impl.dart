import '../../../models/authorization.dart';
import '../../../models/user.dart';
import '../base_client.dart';
import '../user.client.dart';

class UserClientImpl extends BaseClient implements UserClient {
  UserClientImpl({
    required String host,
    Authorization? authorization,
  }) : super(host, authorization: authorization);

  @override
  Future<Authorization> logIn(String email, String password) async {
    final payload = {'email': email, 'password': password};
    final json = await post('/access/shop/login', payload);
    final tokens = json['tokens'];
    final shop = json['shop'];

    return Authorization(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
        shopId: shop['_id']);
  }

  @override
  Future<User> getProfile() async {
    final json = await get('/access/shop');
    return User.fromJson(json['shop']);
  }

  @override
  Future<void> signOut({String? deviceToken}) {
    final data = {'deviceToken': deviceToken ?? ''};

    return post('/user/logOut', data);
  }

  @override
  Future<List<User>> loadUsers({Map<String, dynamic>? params}) async {
    final json = await get('/shop/search');
    print('=====> json ${json.toString()}');
    return json;
  }
}
