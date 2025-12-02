import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_data_source.dart';

/// Subscription repository implementation
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDataSource _dataSource;

  SubscriptionRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> createSubscription({
    required String userId,
    required SubscriptionPlanType planType,
    required String? paymentProofUrl,
    required String? transferNumber,
  }) async {
    try {
      await _dataSource.createSubscription(
        userId: userId,
        planType: planType,
        paymentProofUrl: paymentProofUrl,
        transferNumber: transferNumber,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity?>> getUserSubscription(
    String userId,
  ) async {
    try {
      final data = await _dataSource.getUserSubscription(userId);
      if (data == null) return const Right(null);

      // Convert to entity
      final subscription = SubscriptionEntity(
        userId: userId,
        planType: SubscriptionPlanType.fromJson(
          data['subscription_type'] as String,
        ),
        amount: SubscriptionPlanType.fromJson(
          data['subscription_type'] as String,
        ).price,
        status: SubscriptionStatus.fromJson(
          data['subscription_status'] as String,
        ),
        startDate: DateTime.parse(data['subscription_start_date'] as String),
        endDate: DateTime.parse(data['subscription_end_date'] as String),
        createdAt: DateTime.parse(data['subscription_start_date'] as String),
      );

      return Right(subscription);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getUserSubscriptions(
    String userId,
  ) async {
    try {
      final dataList = await _dataSource.getUserSubscriptions(userId);

      final subscriptions = dataList.map((data) {
        return SubscriptionEntity(
          userId: data['user_id'] as String,
          planType: SubscriptionPlanType.fromJson(data['plan_type'] as String),
          amount: (data['total_price'] as num).toDouble(),
          paymentProofUrl: data['payment_proof_url'] as String?,
          transferNumber: data['transfer_number'] as String?,
          status: SubscriptionStatus.fromJson(data['status'] as String),
          startDate: DateTime.parse(data['start_date'] as String),
          endDate: DateTime.parse(data['end_date'] as String),
          createdAt: DateTime.parse(data['created_at'] as String),
        );
      }).toList();

      return Right(subscriptions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
