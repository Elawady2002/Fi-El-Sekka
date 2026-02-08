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
                  const Spacer(),
                  // Calendar Icon Button
                  GestureDetector(
                    onTap: onCalendarTap,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        CupertinoIcons.calendar,
                        color: accentColor,
                        size: 24,
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
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            text: 'اشترك الآن',
            onPressed: onSubscribeTap,
            backgroundColor: isPopular ? accentColor : Colors.black,
            textColor: isPopular ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }
}
