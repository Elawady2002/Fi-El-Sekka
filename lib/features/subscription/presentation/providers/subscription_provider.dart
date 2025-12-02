import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/datasources/subscription_data_source.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/subscription_repository_impl.dart';

part 'subscription_provider.g.dart';

@riverpod
SubscriptionDataSource subscriptionDataSource(SubscriptionDataSourceRef ref) {
  return SubscriptionDataSourceImpl(Supabase.instance.client);
}

@riverpod
SubscriptionRepository subscriptionRepository(SubscriptionRepositoryRef ref) {
  final dataSource = ref.watch(subscriptionDataSourceProvider);
  return SubscriptionRepositoryImpl(dataSource);
}

@riverpod
Future<List<SubscriptionEntity>> userSubscriptions(
  UserSubscriptionsRef ref,
) async {
  final authState = ref.watch(authProvider);

  if (authState == null) {
    return [];
  }

  final repository = ref.watch(subscriptionRepositoryProvider);
  final result = await repository.getUserSubscriptions(authState.id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (subscriptions) => subscriptions,
  );
}
