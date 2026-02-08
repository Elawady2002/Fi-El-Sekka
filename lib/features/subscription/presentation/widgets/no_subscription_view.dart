import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/pages/home_page.dart';

class NoSubscriptionView extends StatelessWidget {
  const NoSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.ticket,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'لا يوجد اشتراك نشط حالياً',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'اشترك في باقة الطلاب للاستفادة من المزايا',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Button
            CustomButton(
              text: 'اشترك الآن',
              onPressed: () {
                Navigator.pop(context); // Close current page
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => const LocationSelectionDrawer(
                    navigateToSubscription: true,
                  ),
                );
              },
              backgroundColor: AppTheme.primaryColor,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
