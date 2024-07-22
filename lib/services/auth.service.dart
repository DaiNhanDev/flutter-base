
import '../models/authorization.dart';

abstract class AuthService {
  Future<Authorization> logIn({
    required String email,
    required String password,
  });
}
