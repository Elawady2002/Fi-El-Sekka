import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../payment/presentation/pages/payment_page.dart';

class SubscriptionPlansSheet extends StatefulWidget {
  const SubscriptionPlansSheet({super.key});

  @override
  State<SubscriptionPlansSheet> createState() => _SubscriptionPlansSheetState();
}

class _SubscriptionPlansSheetState extends State<SubscriptionPlansSheet> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'باقة الشهر',
      'price': '600',
      'period': 'شهرياً',
      'features': [
        'رحلات يومية للجامعة',
        'توفير 10% من المصاريف',
        'أولوية في حجز المقاعد',
        'إمكانية تغيير المواعيد',
        'دعم فني مخصص',
      ],
      'isPopular': false,
      'color': Colors.white,
      'accentColor': Colors.blue,
    },
    {
      'title': 'باقة الترم',
      'price': '2000',
      'period': 'للترم',
      'features': [
        'رحلات غير محدودة طوال الترم',
        'توفير 25% من المصاريف',
        'مقعد مميز محجوز باسمك',
        'مرونة كاملة في المواعيد',
        'إلغاء مجاني في أي وقت',
        'هدايا ومفاجآت حصرية',
      ],
      'isPopular': true,
      'color': Colors
          .white, // Will be overridden by logic for popular card if needed
      'accentColor': AppTheme.primaryColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              children: [
                Text(
                  'باقات الطلاب',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اختار الباقة المناسبة ليك ووفر فلوسك',
                  textAlign: TextAlign.center,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Plans PageView
          SizedBox(
            height: 520, // Fixed height for the cards
            child: PageView.builder(
              controller: _pageController,
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildPlanCard(
                    context,
                    title: plan['title'],
                    price: plan['price'],
                    period: plan['period'],
                    features: plan['features'],
                    isPopular: plan['isPopular'],
                    accentColor: plan['accentColor'],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isPopular,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => PaymentPage(planName: title, amount: price),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPopular ? accentColor : Colors.grey.shade200,
            width: isPopular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'الاكثر توفيرا',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: AppTheme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ج.م',
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        ' / $period',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Features List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_alt,
                        color: isPopular ? accentColor : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          features[index],
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            PaymentPage(planName: title, amount: price),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? accentColor : Colors.black,
                    foregroundColor: isPopular ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'اشترك الآن',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
