import '../../models/authorization.dart';

abstract class AuthClient {
  Future<Authorization> logIn(String email, String password);
}
