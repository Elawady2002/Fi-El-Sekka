import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/utils/logger.dart';
import '../providers/subscription_provider.dart';
import '../../domain/entities/subscription_entity.dart';
import '../widgets/active_subscription_widget.dart';
import '../widgets/no_subscription_widget.dart';

class MySubscriptionPage extends ConsumerStatefulWidget {
  const MySubscriptionPage({super.key});

  @override
  ConsumerState<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends ConsumerState<MySubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final subscriptionState = ref.watch(userSubscriptionsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        border: null,
        middle: Text(
          'اشتراكي',
          style: AppTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
      ),
      body: user == null
          ? const Center(child: Text('يرجى تسجيل الدخول'))
          : subscriptionState.when(
              data: (subscriptions) {
                AppLogger.info(
                  'DEBUG MySubscriptionPage: Found ${subscriptions.length} subscriptions',
                );
                for (var sub in subscriptions) {
                  AppLogger.info(
                    '  - ID: ${sub.id}, Status: ${sub.status}, Type: ${sub.planType}',
                  );
                }

                // Find active or pending subscription
                final activeSubscription = subscriptions.firstWhere(
                  (sub) =>
                      sub.status == SubscriptionStatus.active ||
                      sub.status == SubscriptionStatus.pending,
                  orElse: () => SubscriptionEntity(
                    id: '',
                    userId: '',
                    planType: SubscriptionPlanType.monthly,
                    amount: 0,
                    startDate: DateTime.now(),
                    endDate: DateTime.now(),
                    createdAt: DateTime.now(),
                    status: SubscriptionStatus.expired,
                    paymentProofUrl: '',
                  ),
                );

                if (activeSubscription.id == null ||
                    activeSubscription.id!.isEmpty) {
                  AppLogger.info(
                    'DEBUG MySubscriptionPage: No active/pending subscription found',
                  );
                  return const NoSubscriptionView();
                }

                AppLogger.info(
                  'DEBUG MySubscriptionPage: Showing subscription ${activeSubscription.id}',
                );
                return ActiveSubscriptionView(subscription: activeSubscription);
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (error, stack) => Center(child: Text('حدث خطأ: $error')),
            ),
    );
  }
}
