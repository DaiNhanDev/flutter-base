import '../models/authorization.dart';

abstract class AuthRepository {
  Future<Authorization> logIn({
    required String email,
    required String password,
  });
}
