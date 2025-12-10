import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription_entity.dart';

/// Subscription repository interface
abstract class SubscriptionRepository {
  /// Create a new subscription for a user
  Future<Either<Failure, void>> createSubscription({
    required String userId,
    required SubscriptionPlanType planType,
    required String? paymentProofUrl,
    required String? transferNumber,
    bool isInstallment = false,
    SubscriptionScheduleParams? scheduleParams,
  });

  /// Get user's active subscription
  Future<Either<Failure, SubscriptionEntity?>> getUserSubscription(
    String userId,
  );

  /// Get all user subscriptions (transaction history)
  Future<Either<Failure, List<SubscriptionEntity>>> getUserSubscriptions(
    String userId,
  );

  /// Cancel a subscription
  Future<Either<Failure, void>> cancelSubscription(String subscriptionId);
}
