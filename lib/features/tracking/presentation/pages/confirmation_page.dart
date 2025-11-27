import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import 'tracking_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/domain/entities/trip_type.dart';

class ConfirmationPage extends ConsumerWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);
    final bookingNotifier = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppTheme.primaryColor,
                  size: 64,
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),
              Text(
                "تم تأكيد الحجز!",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              Text(
                "رحلتك تم تأكيدها بنجاح. ممكن تتابع الأتوبيس بتاعك لايف.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      "نوع الرحلة",
                      bookingState.tripType.displayName,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      "التاريخ",
                      DateFormat(
                        'd MMMM y',
                        'ar',
                      ).format(bookingState.selectedDate),
                    ),
                    if (bookingState.tripType == TripType.departureOnly ||
                        bookingState.tripType == TripType.roundTrip) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        "ميعاد الذهاب",
                        bookingState.selectedDepartureTime ?? '--',
                      ),
                    ],
                    if (bookingState.tripType == TripType.returnOnly ||
                        bookingState.tripType == TripType.roundTrip) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        "ميعاد العودة",
                        bookingState.selectedReturnTime ?? '--',
                      ),
                    ],
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      "السعر",
                      "${bookingNotifier.totalPrice.toStringAsFixed(0)} جنيه",
                      isHighlighted: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const Spacer(),
              CustomButton(
                text: "تتبع الأتوبيس",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrackingPage()),
                  );
                },
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Text(
                  "رجوع للرئيسية",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isHighlighted
                ? AppTheme.textPrimary
                : AppTheme.textSecondary,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlighted ? AppTheme.primaryColor : AppTheme.textPrimary,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
