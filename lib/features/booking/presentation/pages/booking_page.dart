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

import '../widgets/booking_date_card.dart';
import '../widgets/time_selection_card.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../domain/entities/schedule_entity.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
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

                  // Trip Type Selector


                  // Date Picker
                  _buildSectionTitle('التاريخ'),
                  const SizedBox(height: 16),
                  BookingDateCard(
                    selectedDate: bookingState.selectedDate,
                    onDateSelected: bookingNotifier.selectDate,
                  ),

                  // Schedule Selection
                  ..._buildScheduleSections(context, ref, bookingState, bookingNotifier),

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

  List<Widget> _buildScheduleSections(
    BuildContext context,
    WidgetRef ref,
    BookingStateModel state,
    BookingState bookingNotifier,
  ) {
    // For now, if no university is selected, use a fake ID to show fake schedules
    final universityId = state.selectedUniversity?.id ?? 'fake-uni-id';
    final routesAsync = ref.watch(routesProvider(universityId));

    return routesAsync.when(
      data: (routes) {
        if (routes.isEmpty) {
          return [const Center(child: Text('لا يوجد رحلات متاحة لهذه الجامعة'))];
        }

        // For now, we take the first route. Ideally, we match by station or let user select.
        final route = routes.first;
        final schedulesAsync = ref.watch(schedulesProvider(route.id));

        return [
          schedulesAsync.when(
            data: (schedules) {
              final allSchedules = schedules;
              final selectedSchedule = state.selectedDepartureSchedule ?? state.selectedReturnSchedule;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildSectionTitle('موعد الرحلة'),
                  const SizedBox(height: 16),
                  TimeSelectionCard(
                    title: 'اختار ميعاد الرحلة',
                    selectedTime: selectedSchedule != null 
                        ? _formatTime(selectedSchedule.departureTime) 
                        : null,
                    icon: CupertinoIcons.clock,
                    onTap: () {
                      final items = allSchedules.map((s) => _formatTime(s.departureTime)).toList();
                      _showTimePicker(
                        title: 'موعد الرحلة',
                        items: items,
                        onSelect: (time) {
                          if (time != null) {
                            final schedule = allSchedules.firstWhere(
                              (s) => _formatTime(s.departureTime) == time
                            );
                            bookingNotifier.selectDepartureSchedule(schedule);
                          }
                        },
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ];
      },
      loading: () => [const Center(child: CupertinoActivityIndicator())],
      error: (err, _) => [Center(child: Text('Error: $err'))],
    );
  }

  String _formatTime(String time) {
    // Basic formatting from "HH:mm" to "h:mm a" if needed, 
    // but the entity says "departureTime" is String.
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final dt = DateTime(2022, 1, 1, hour, minute);
      return DateFormat('h:mm a', 'ar').format(dt);
    } catch (e) {
      return time;
    }
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
