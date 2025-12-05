import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../booking/data/datasources/booking_data_source.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../../subscription/domain/entities/subscription_entity.dart';

/// Unified calendar card for both subscriptions and regular bookings
class UnifiedBookingCard extends ConsumerStatefulWidget {
  final SubscriptionEntity? subscription;
  final List<BookingEntity> regularBookings;

  const UnifiedBookingCard({
    super.key,
    this.subscription,
    this.regularBookings = const [],
  });

  @override
  ConsumerState<UnifiedBookingCard> createState() => _UnifiedBookingCardState();
}

class _UnifiedBookingCardState extends ConsumerState<UnifiedBookingCard> {
  DateTime _currentMonth = DateTime.now();
  Map<String, BookingEntity> _allBookings = {};

  // Time selection state
  String _selectedTripType = 'round_trip';
  String? _selectedDepartureTime;
  String? _selectedReturnTime;

  @override
  void initState() {
    super.initState();
    _fetchAllBookings();
  }

  Future<void> _fetchAllBookings() async {
    // Fetch all bookings

    try {
      final Map<String, BookingEntity> bookingsMap = {};

      // 1. Fetch subscription bookings if subscription exists
      if (widget.subscription != null) {
        final response = await Supabase.instance.client
            .from('bookings')
            .select()
            .eq('subscription_id', widget.subscription!.id!)
            .order('booking_date');

        for (var data in response) {
          final booking = _bookingFromJson(data);
          final dateKey = booking.bookingDate.toIso8601String().split('T')[0];
          bookingsMap[dateKey] = booking;
        }
      }

      // 2. Add regular bookings
      for (var booking in widget.regularBookings) {
        final dateKey = booking.bookingDate.toIso8601String().split('T')[0];
        bookingsMap[dateKey] = booking;
      }

      if (mounted) {
        setState(() {
          _allBookings = bookingsMap;
        });
      }
    } catch (e) {
      // Error fetching bookings
    }
  }

  BookingEntity _bookingFromJson(Map<String, dynamic> json) {
    return BookingEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      scheduleId: json['schedule_id'] as String? ?? '',
      bookingDate: DateTime.parse(json['booking_date'] as String),
      tripType: json['trip_type'] as String,
      pickupStationId: json['pickup_station_id'] as String?,
      dropoffStationId: json['dropoff_station_id'] as String?,
      departureTime: json['departure_time'] as String?,
      returnTime: json['return_time'] as String?,
      status: BookingStatus.fromJson(json['status'] as String),
      paymentStatus: PaymentStatus.fromJson(json['payment_status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.parse(json['created_at'] as String),
      subscriptionId: json['subscription_id'] as String?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: [_buildHeader(), _buildCalendar()]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.subscription != null ? 'اشتراكك النشط' : 'حجوزاتك القادمة',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_allBookings.length} حجز',
              style: AppTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 16),
          _buildWeekdayHeaders(),
          const SizedBox(height: 8),
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
          icon: const Icon(CupertinoIcons.chevron_right, color: Colors.white),
        ),
        Text(
          DateFormat('MMMM yyyy', 'ar').format(_currentMonth),
          style: AppTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
          icon: const Icon(CupertinoIcons.chevron_left, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['س', 'ج', 'خ', 'أ', 'ث', 'ا', 'ح'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final dateKey = date.toIso8601String().split('T')[0];
    final hasBooking = _allBookings.containsKey(dateKey);
    final booking = _allBookings[dateKey];
    final isFromSubscription = booking?.subscriptionId != null;
    final isToday = _isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: hasBooking ? () => _showBookingDetails(booking!) : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: hasBooking
              ? (isFromSubscription
                    ? AppTheme.primaryColor
                    : Colors.blue.shade400)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday ? Border.all(color: Colors.red, width: 2) : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: hasBooking ? Colors.black : Colors.white54,
              fontWeight: hasBooking ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showBookingDetails(BookingEntity booking) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'تفاصيل الحجز',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildDetailRow(
                    'التاريخ',
                    DateFormat('d MMMM yyyy', 'ar').format(booking.bookingDate),
                  ),
                  _buildDetailRow(
                    'نوع الرحلة',
                    _getTripTypeLabel(booking.tripType),
                  ),
                  if (booking.departureTime != null)
                    _buildDetailRow('ميعاد الذهاب', booking.departureTime!),
                  if (booking.returnTime != null)
                    _buildDetailRow('ميعاد العودة', booking.returnTime!),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: () {
                      Navigator.pop(context);
                      _showTimeEditor(booking);
                    },
                    child: const Text('تعديل المواعيد'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getTripTypeLabel(String tripType) {
    switch (tripType) {
      case 'departure_only':
        return 'ذهاب فقط';
      case 'return_only':
        return 'عودة فقط';
      case 'round_trip':
        return 'ذهاب وعودة';
      default:
        return tripType;
    }
  }

  void _showTimeEditor(BookingEntity booking) {
    setState(() {
      _selectedTripType = booking.tripType;
      _selectedDepartureTime = booking.departureTime;
      _selectedReturnTime = booking.returnTime;
    });

    showCupertinoModalPopup(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'تعديل المواعيد',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    if (_selectedTripType == 'departure_only' ||
                        _selectedTripType == 'round_trip')
                      _buildTimeSelector(
                        'ميعاد الذهاب',
                        _selectedDepartureTime,
                        ['AM 6:00', 'AM 6:30', 'AM 7:00', 'AM 7:30', 'AM 8:00'],
                        (time) =>
                            setModalState(() => _selectedDepartureTime = time),
                      ),
                    if (_selectedTripType == 'return_only' ||
                        _selectedTripType == 'round_trip')
                      _buildTimeSelector(
                        'ميعاد العودة',
                        _selectedReturnTime,
                        ['PM 2:00', 'PM 2:30', 'PM 3:00', 'PM 3:30', 'PM 4:00'],
                        (time) =>
                            setModalState(() => _selectedReturnTime = time),
                      ),
                    const SizedBox(height: 24),
                    CupertinoButton.filled(
                      onPressed: () async {
                        await _updateBookingTimes(booking.id);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('حفظ التعديلات'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
    String label,
    String? selectedTime,
    List<String> times,
    ValueChanged<String> onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: times
              .map(
                (time) => GestureDetector(
                  onTap: () => onSelect(time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selectedTime == time
                          ? AppTheme.primaryColor
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedTime == time
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      time,
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: selectedTime == time
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selectedTime == time
                            ? Colors.black
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _updateBookingTimes(String bookingId) async {
    try {
      final bookingDataSource = BookingDataSourceImpl();
      await bookingDataSource.updateBookingTimes(
        bookingId: bookingId,
        departureTime: _selectedDepartureTime,
        returnTime: _selectedReturnTime,
      );

      HapticFeedback.heavyImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث المواعيد بنجاح')),
        );
      }

      // Refresh bookings
      await _fetchAllBookings();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}
