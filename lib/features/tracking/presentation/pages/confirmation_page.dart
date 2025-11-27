import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../../../../core/widgets/ticket_card.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../booking/presentation/providers/booking_provider.dart';

class ConfirmationPage extends ConsumerWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);
    final bookingNotifier = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(
        0xFF8B5CF6,
      ), // Violet background like reference
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Ticket Card
              Expanded(
                child: Center(
                  child: TicketCard(
                    punchY: 0.72, // Adjust punch position
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          // Header
                          Center(
                            child: Text(
                              "تذكرة الحجز",
                              style: AppTheme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Features / Checks
                          _buildCheckItem(context, "تم الدفع بنجاح"),
                          const SizedBox(height: 12),
                          _buildCheckItem(context, "تم حجز المقعد"),
                          const SizedBox(height: 12),
                          _buildCheckItem(context, "الفاتورة جاهزة"),

                          const SizedBox(height: 32),

                          // Price Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF08A), // Yellow bg
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "مدفوع",
                              style: AppTheme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${bookingNotifier.totalPrice.toStringAsFixed(0)} جنيه",
                            style: AppTheme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 48,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Trip Details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "التاريخ",
                                    style: AppTheme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat(
                                      'd MMM',
                                      'ar',
                                    ).format(bookingState.selectedDate),
                                    style: AppTheme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "نوع الرحلة",
                                    style: AppTheme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bookingState.tripType.displayName,
                                    style: AppTheme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Bottom Section (Below dashed line)
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.28 -
                                48, // Approximate height of bottom section
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IOSButton(
                                  text: "رجوع للرئيسية",
                                  color: const Color(0xFF1F2937), // Dark button
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF65A30D), // Green
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
