import '../../data/client/auth.client.dart';
import '../../models/authorization.dart';
import '../auth.repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthClient _authClient;

  AuthRepositoryImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<Authorization> logIn({
    required String email,
    required String password,
  }) async {
    final authorization = await _authClient.logIn(email, password);
    return authorization;
  }
}
