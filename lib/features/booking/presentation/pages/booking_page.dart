import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../../domain/entities/trip_type.dart';
import '../providers/booking_provider.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../widgets/student_packages_button.dart';
import '../widgets/trip_type_selector.dart';
import '../widgets/booking_date_card.dart';
import '../widgets/time_selection_card.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final departureTimes = [
    'AM 6:00',
    'AM 6:30',
    'AM 7:00',
    'AM 7:30',
    'AM 8:00',
  ];

  final returnTimes = ['PM 2:00', 'PM 2:30', 'PM 3:00', 'PM 3:30', 'PM 4:00'];

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final bookingNotifier = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppTheme.floatingShadow,
                      ),
                      child: const Icon(
                        CupertinoIcons.chevron_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'احجز رحلتك',
                    style: AppTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Student Packages Button
                  const StudentPackagesButton(),
                  const SizedBox(height: 24),

                  // Same-day booking warning - AT THE TOP
                  if (!bookingNotifier.isSameDayBookingAllowed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.info_circle_fill,
                            color: Colors.orange.shade800,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'الحجز في نفس اليوم متاح بس قبل الساعة 7 الصبح',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Trip Type Selector
                  _buildSectionTitle('نوع الرحلة'),
                  const SizedBox(height: 16),
                  TripTypeSelector(
                    selectedType: bookingState.tripType,
                    onSelect: bookingNotifier.selectTripType,
                  ),

                  const SizedBox(height: 32),

                  // Date Picker
                  _buildSectionTitle('التاريخ'),
                  const SizedBox(height: 16),
                  BookingDateCard(
                    selectedDate: bookingState.selectedDate,
                    onDateSelected: bookingNotifier.selectDate,
                  ),

                  const SizedBox(height: 32),

                  // Time Selection
                  if (bookingState.tripType == TripType.departureOnly ||
                      bookingState.tripType == TripType.roundTrip) ...[
                    _buildSectionTitle('ميعاد الذهاب'),
                    const SizedBox(height: 16),
                    TimeSelectionCard(
                      title: 'وقت التحرك',
                      selectedTime: bookingState.selectedDepartureTime,
                      icon: CupertinoIcons.arrow_up_circle_fill,
                      onTap: () => _showTimePicker(
                        title: 'اختار ميعاد الذهاب',
                        items: departureTimes,
                        onSelect: bookingNotifier.selectDepartureTime,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  if (bookingState.tripType == TripType.returnOnly ||
                      bookingState.tripType == TripType.roundTrip) ...[
                    _buildSectionTitle('ميعاد العودة'),
                    const SizedBox(height: 16),
                    TimeSelectionCard(
                      title: 'وقت الرجوع',
                      selectedTime: bookingState.selectedReturnTime,
                      icon: CupertinoIcons.arrow_down_circle_fill,
                      onTap: () => _showTimePicker(
                        title: 'اختار ميعاد العودة',
                        items: returnTimes,
                        onSelect: bookingNotifier.selectReturnTime,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Bottom Button
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
              child: IOSButton(
                text: 'ادفع',
                onPressed:
                    bookingNotifier.isBookingComplete &&
                        bookingNotifier.isSameDayBookingAllowed
                    ? () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PaymentPage(
                              planName: bookingState.tripType.displayName,
                              amount: bookingState.tripType.price
                                  .toStringAsFixed(0),
                            ),
                          ),
                        );
                      }
                    : null,
                color:
                    bookingNotifier.isBookingComplete &&
                        bookingNotifier.isSameDayBookingAllowed
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  void _showTimePicker({
    required String title,
    required List<String> items,
    required void Function(String?) onSelect,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 340,
        decoration: const BoxDecoration(
          color: Colors.white,
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
          children: [
            const SizedBox(height: 12),
            // Drag Handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Header with Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFFF3B30),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'تم',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Picker
            Expanded(
              child: CupertinoPicker.builder(
                itemExtent: 48,
                magnification: 1.1,
                useMagnifier: true,
                backgroundColor: Colors.transparent,
                selectionOverlay: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSelectedItemChanged: (index) {
                  onSelect(items[index]);
                },
                childCount: items.length,
                itemBuilder: (context, index) => Center(
                  child: GestureDetector(
                    onTap: () {
                      onSelect(items[index]);
                      Navigator.pop(context);
                    },
                    child: Text(
                      items[index],
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
