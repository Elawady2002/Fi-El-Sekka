import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../../domain/entities/trip_type.dart';
import '../providers/booking_provider.dart';
import '../../../tracking/presentation/pages/confirmation_page.dart';
import '../../../subscription/presentation/widgets/subscription_plans_sheet.dart';

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
                  _buildTripTypeSelector(
                    bookingState.tripType,
                    bookingNotifier,
                  ),

                  const SizedBox(height: 32),

                  // Date Picker
                  _buildSectionTitle('التاريخ'),
                  const SizedBox(height: 16),
                  _buildDateCard(bookingState.selectedDate, bookingNotifier),

                  const SizedBox(height: 32),

                  // Time Selection
                  if (bookingState.tripType == TripType.departureOnly ||
                      bookingState.tripType == TripType.roundTrip) ...[
                    _buildSectionTitle('ميعاد الذهاب'),
                    const SizedBox(height: 16),
                    _buildTimeSelectionCard(
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
                    _buildTimeSelectionCard(
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

                  // Student Packages Button
                  _buildStudentPackagesButton(),

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
                text: 'كمل الحجز',
                onPressed:
                    bookingNotifier.isBookingComplete &&
                        bookingNotifier.isSameDayBookingAllowed
                    ? () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ConfirmationPage(),
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

  Widget _buildTripTypeSelector(TripType selectedType, BookingState notifier) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: TripType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => notifier.selectTripType(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Text(
                      type.displayName,
                      textAlign: TextAlign.center,
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.black
                            : AppTheme.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${type.price.toStringAsFixed(0)} جنيه',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.primaryDark
                            : AppTheme.textTertiary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateCard(DateTime selectedDate, BookingState notifier) {
    return GestureDetector(
      onTap: () => _showDatePicker(selectedDate, notifier),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.calendar,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تاريخ الرحلة',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE، d MMMM', 'ar').format(selectedDate),
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateFormat('yyyy', 'ar').format(selectedDate),
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(DateTime currentDate, BookingState notifier) async {
    // Ensure initial date is not before today
    final now = DateTime.now();
    final initialDate = currentDate.isBefore(now) ? now : currentDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 1), // Next year only
      locale: const Locale('ar', 'EG'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      notifier.selectDate(selectedDate);
    }
  }

  Widget _buildTimeSelectionCard({
    required String title,
    required String? selectedTime,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedTime != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.black : AppTheme.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedTime ?? 'اختار الميعاد',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.black : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              color: AppTheme.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentPackagesButton() {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => const SubscriptionPlansSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A), // Dark charcoal
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.star_fill,
                color: Color(0xFFFFD700), // Gold
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'باقات الطلاب المميزة',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'وفر فلوسك مع باقات الشهر والترم',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
                size: 16,
              ),
            ),
          ],
        ),
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
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
