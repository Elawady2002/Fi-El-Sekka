import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) =>
      _repository.signIn(email: email, password: password);
}
