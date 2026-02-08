import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../booking/data/datasources/booking_data_source.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/datasources/subscription_data_source.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/logger_service.dart';
import '../../data/repositories/subscription_repository_impl.dart';

part 'subscription_provider.g.dart';

@riverpod
SubscriptionDataSource subscriptionDataSource(Ref ref) {
  return SubscriptionDataSourceImpl(Supabase.instance.client);
}

@riverpod
SubscriptionRepository subscriptionRepository(Ref ref) {
  final dataSource = ref.watch(subscriptionDataSourceProvider);
  // Create BookingDataSource directly instead of using a provider
  final bookingDataSource = BookingDataSourceImpl();
  return SubscriptionRepositoryImpl(dataSource, bookingDataSource);
}

// User Subscriptions Provider (all subscriptions)
@riverpod
Future<List<SubscriptionEntity>> userSubscriptions(Ref ref) async {
  final user = ref.watch(authProvider);


  final repository = ref.watch(subscriptionRepositoryProvider);
  final result = await repository.getUserSubscriptions(user.id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (subscriptions) => subscriptions,
  );
}

// Active Subscription Provider (current active subscription)
@riverpod
Future<SubscriptionEntity?> activeSubscription(Ref ref) async {
  final subscriptions = await ref.watch(userSubscriptionsProvider.future);

  // Find the first active or pending subscription
  try {
    LoggerService.info(
      'DEBUG: Filtering ${subscriptions.length} subscriptions for active/pending',
    );
    final activeSub = subscriptions.firstWhere((sub) {
      final isActiveOrPending =
          sub.status == SubscriptionStatus.active ||
          sub.status == SubscriptionStatus.pending;
      final isNotExpired = sub.endDate.isAfter(DateTime.now());
      LoggerService.info(
        'DEBUG: Sub ${sub.id}: Status=${sub.status}, End=${sub.endDate}, Active/Pending=$isActiveOrPending, NotExpired=$isNotExpired',
      );
      return isActiveOrPending && isNotExpired;
    });
    LoggerService.info('DEBUG: Found active subscription: ${activeSub.id}');
    return activeSub;
  } catch (e) {
    LoggerService.info('DEBUG: No active subscription found: $e');
    return null;
  }
}
