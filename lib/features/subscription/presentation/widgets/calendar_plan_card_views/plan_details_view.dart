import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../domain/entities/subscription_entity.dart';

class PlanDetailsView extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final Color accentColor;
  final VoidCallback onCalendarTap;
  final VoidCallback onSubscribeTap;

  const PlanDetailsView({
    super.key,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
    required this.accentColor,
    required this.onCalendarTap,
    required this.onSubscribeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('details'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      letterSpacing: -1,
                    ),
                  ),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'الأكثر توفيراً',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 64,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ج.م',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          period,
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Calendar Icon Button
                  GestureDetector(
                    onTap: onCalendarTap,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.calendar,
                        color: Colors.black87,
                        size: 26,
                      ),
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
            // physics: const NeverScrollableScrollPhysics(), // Removed to allow scrolling
            itemCount: features.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.checkmark_alt,
                    color: isPopular ? accentColor : Colors.black,
                    size: 20,
                    // Use a fallback icon if checkmark is not available or just to be safe
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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: CustomButton(
            text: 'اشترك الآن',
            onPressed: onSubscribeTap,
            backgroundColor: isPopular ? accentColor : Colors.black,
            textColor: Colors.black,
            height: 60,
          ),
        ),
      ],
    );
  }
}
