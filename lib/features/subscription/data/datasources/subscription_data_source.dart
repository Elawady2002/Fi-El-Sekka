import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/subscription_entity.dart';

/// Subscription data source interface
abstract class SubscriptionDataSource {
  Future<void> createSubscription({
    required String userId,
    required SubscriptionPlanType planType,
    required String? paymentProofUrl,
    required String? transferNumber,
  });

  Future<Map<String, dynamic>?> getUserSubscription(String userId);

  Future<List<Map<String, dynamic>>> getUserSubscriptions(String userId);
}

/// Subscription data source implementation
class SubscriptionDataSourceImpl implements SubscriptionDataSource {
  final SupabaseClient _supabase;

  SubscriptionDataSourceImpl(this._supabase);

  @override
  Future<void> createSubscription({
    required String userId,
    required SubscriptionPlanType planType,
    required String? paymentProofUrl,
    required String? transferNumber,
  }) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: planType.durationDays));

      AppLogger.info('Creating subscription for user $userId');
      AppLogger.info(
        'Plan: ${planType.name}, Duration: ${planType.durationDays} days',
      );
      AppLogger.info('Start: $now, End: $endDate');

      // Insert into subscriptions table (transaction record)
      await _supabase.from('subscriptions').insert({
        'user_id': userId,
        'plan_type': planType.name,
        'total_price': planType.price,
        'payment_proof_url': paymentProofUrl,
        'transfer_number': transferNumber,
        'status': SubscriptionStatus.pending.name,
        'start_date': now.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      });

      // Update user's profile with current subscription details
      await _supabase
          .from('users')
          .update({
            'subscription_type': planType.name,
            'subscription_start_date': now.toIso8601String(),
            'subscription_end_date': endDate.toIso8601String(),
            'subscription_status': SubscriptionStatus.pending.name,
          })
          .eq('id', userId);

      AppLogger.info('✅ Subscription created successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create subscription', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserSubscription(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select(
            'subscription_type, subscription_start_date, subscription_end_date, subscription_status',
          )
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get user subscription', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserSubscriptions(String userId) async {
    try {
      final response = await _supabase
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get user subscriptions', e, stackTrace);
      rethrow;
    }
  }
}
