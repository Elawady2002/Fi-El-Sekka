import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/domain/entities/booking_entity.dart';

class RideHistoryPage extends ConsumerStatefulWidget {
  const RideHistoryPage({super.key});

  @override
  ConsumerState<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends ConsumerState<RideHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'سجل الرحلات',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryDark,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUpcomingRides(), _buildPastRides()],
      ),
    );
  }

  Widget _buildUpcomingRides() {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return bookingsAsync.when(
      data: (bookings) {
        final upcomingBookings = bookings
            .where(
              (b) =>
                  b.bookingDate.isAfter(DateTime.now()) &&
                  (b.status == BookingStatus.pending ||
                      b.status == BookingStatus.confirmed),
            )
            .toList();

        if (upcomingBookings.isEmpty) {
          return _buildEmptyState('لا توجد رحلات قادمة');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: upcomingBookings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final booking = upcomingBookings[index];
            return _buildRideCard(booking);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildPastRides() {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return bookingsAsync.when(
      data: (bookings) {
        final pastBookings = bookings
            .where(
              (b) =>
                  b.bookingDate.isBefore(DateTime.now()) ||
                  b.status == BookingStatus.cancelled ||
                  b.status == BookingStatus.completed,
            )
            .toList();

        if (pastBookings.isEmpty) {
          return _buildEmptyState('لا توجد رحلات سابقة');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: pastBookings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final booking = pastBookings[index];
            return _buildRideCard(booking);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildRideCard(BookingEntity booking) {
    final statusInfo = _getStatusInfo(booking.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التاريخ: ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نوع الرحلة: ${_getTripTypeLabel(booking.tripType)}',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${booking.totalPrice.toStringAsFixed(0)} ج.م',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusInfo['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusInfo['label'],
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: statusInfo['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.ticket, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_triangle,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل الرحلات',
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return {'label': 'مؤكد', 'color': AppTheme.successColor};
      case BookingStatus.pending:
        return {'label': 'قيد الانتظار', 'color': Colors.orange};
      case BookingStatus.cancelled:
        return {'label': 'ملغي', 'color': AppTheme.errorColor};
      case BookingStatus.completed:
        return {'label': 'مكتمل', 'color': Colors.grey};
    }
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
}
