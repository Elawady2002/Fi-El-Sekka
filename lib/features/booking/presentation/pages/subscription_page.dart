import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/plan_card.dart';
import '../providers/booking_provider.dart';
import 'scheduling_page.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'يومي',
      'price': '50 جنيه',
      'duration': 'يوم',
      'features': ['رحلة ذهاب وعودة واحدة', 'مواعيد مرنة', 'كرسي عادي'],
    },
    {
      'title': 'شهري',
      'price': '1200 جنيه',
      'duration': 'شهر',
      'features': [
        'رحلات غير محدودة',
        'كرسي محجوز',
        'دعم فني مميز',
        'إلغاء مجاني',
      ],
    },
    {
      'title': 'ترم كامل',
      'price': '4500 جنيه',
      'duration': 'ترم',
      'features': [
        'اشتراك الترم كله',
        'اختار الكرسي اللي يعجبك',
        'دعم فني 24/7',
        'مميزات حصرية',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final selectedIndex = bookingState.selectedPlanIndex;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "اختار الباقة",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  final plan = _plans[index];
                  return PlanCard(
                    title: plan['title'],
                    price: plan['price'],
                    duration: plan['duration'],
                    features: plan['features'],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      ref.read(bookingStateProvider.notifier).selectPlan(index);
                    },
                  ).animate().fadeIn(delay: (100 * index).ms).slideX();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الإجمالي",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        _plans[selectedIndex]['price'],
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "الدفع",
                    onPressed: () {
                      // Navigate to Scheduling
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SchedulingPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).animate().slideY(begin: 1, end: 0),
          ],
        ),
      ),
    );
  }
}
