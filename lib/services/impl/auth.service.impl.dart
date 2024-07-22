import '../../models/authorization.dart';
import '../../repositories/auth.repository.dart';
import '../../repositories/repository.dart';
import '../auth.service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  AuthServiceImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<Authorization> logIn({
    required String email,
    required String password,
  }) async {
    final authorization  =
        _authRepository.logIn(email: email, password: password);

    Repository().authorization = authorization as Authorization?;


    return authorization;
  }
}
