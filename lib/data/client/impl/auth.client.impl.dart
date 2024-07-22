import '../../../models/authorization.dart';
import '../auth.client.dart';
import '../base_client.dart';

class AuthClientImpl extends BaseClient implements AuthClient {
  AuthClientImpl({
    required String host,
    Authorization? authorization,
  }) : super(host, authorization: authorization);

  @override
  Future<Authorization> logIn(String email, String password) async {
    final payload = {'email': email, 'password': password};
    final json = await post('/access/shop/login', payload);
    print('====> JSON: $json');
    final tokens = json['tokens'];
    final shopId = json['_id'];
    return Authorization(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
        shopId: shopId);
  }
}
