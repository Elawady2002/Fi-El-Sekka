import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class CreateSubscriptionUseCase {
  final SubscriptionRepository _repository;

  CreateSubscriptionUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required SubscriptionPlanType planType,
    required String? paymentProofUrl,
    required String? transferNumber,
    bool isInstallment = false,
    SubscriptionScheduleParams? scheduleParams,
  }) =>
      _repository.createSubscription(
        userId: userId,
        planType: planType,
        paymentProofUrl: paymentProofUrl,
        transferNumber: transferNumber,
        isInstallment: isInstallment,
        scheduleParams: scheduleParams,
      );
}
