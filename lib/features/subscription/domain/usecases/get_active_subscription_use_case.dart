import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetActiveSubscriptionUseCase {
  final SubscriptionRepository _repository;

  GetActiveSubscriptionUseCase(this._repository);

  Future<Either<Failure, SubscriptionEntity?>> call(String userId) =>
      _repository.getUserSubscription(userId);
}
