import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/subscription_repository.dart';

class CancelSubscriptionUseCase {
  final SubscriptionRepository _repository;

  CancelSubscriptionUseCase(this._repository);

  Future<Either<Failure, void>> call(String subscriptionId) =>
      _repository.cancelSubscription(subscriptionId);
}
