import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../booking/domain/entities/booking_entity.dart';
import '../../../subscription/domain/entities/subscription_entity.dart';
import '../../../subscription/domain/entities/subscription_schedule_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'full_screen_booking_view.dart';

class ActiveSubscriptionCard extends ConsumerStatefulWidget {
  final SubscriptionEntity subscription;
  final List<BookingEntity> regularBookings;

  const ActiveSubscriptionCard({
    super.key,
    required this.subscription,
    this.regularBookings = const [],
  });

  @override
  ConsumerState<ActiveSubscriptionCard> createState() =>
      _ActiveSubscriptionCardState();
}

class _ActiveSubscriptionCardState extends ConsumerState<ActiveSubscriptionCard>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  String? _selectedDepartureTime;
  String? _selectedReturnTime;
  // String _selectedTripType = 'round_trip'; // Removed unused field
  String? _universityName;
  Map<String, SubscriptionScheduleEntity> _schedules = {};
  double _dragOffsetY = 0.0;
  late AnimationController _springController;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();
    // Default to today, but will be updated by _fetchSchedules
    _selectedDate = DateTime.now();
    _fetchSchedules();
    _fetchUniversityName();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(ActiveSubscriptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh calendar when regularBookings list changes
    if (oldWidget.regularBookings.length != widget.regularBookings.length) {
      _fetchSchedules();
    }
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  Future<void> _fetchUniversityName() async {
    final user = ref.read(authProvider);
    if (user?.universityId != null) {
      try {
        final response = await Supabase.instance.client
            .from('universities')
            .select('name')
            .eq('id', user!.universityId!)
            .single();
        if (mounted) {
          setState(() {
            _universityName = response['name'] as String;
          });
        }
      } catch (e) {
        debugPrint('Error fetching university name: $e');
      }
    }
  }

  Future<void> _fetchSchedules() async {
    if (widget.subscription.id == null) return;

    try {
      final Map<String, SubscriptionScheduleEntity> schedulesMap = {};

      // 1. Fetch subscription bookings from bookings table
      final response = await Supabase.instance.client
          .from('bookings')
          .select()
          .eq('subscription_id', widget.subscription.id!)
          .order('booking_date');

      for (var booking in response) {
        final bookingDate = DateTime.parse(booking['booking_date'] as String);
        final dateKey = bookingDate.toIso8601String().split('T')[0];

        schedulesMap[dateKey] = SubscriptionScheduleEntity(
          id: booking['id'] as String,
          subscriptionId: booking['subscription_id'] as String,
          tripDate: bookingDate,
          tripType: booking['trip_type'] as String,
          departureTime: booking['departure_time'] as String?,
          returnTime: booking['return_time'] as String?,
          createdAt: DateTime.parse(booking['created_at'] as String),
          updatedAt: booking['updated_at'] != null
              ? DateTime.parse(booking['updated_at'] as String)
              : DateTime.parse(booking['created_at'] as String),
        );
      }

      // 2. Add regular bookings from widget.regularBookings
      for (var booking in widget.regularBookings) {
        final dateKey = booking.bookingDate.toIso8601String().split('T')[0];

        // Convert BookingEntity to SubscriptionScheduleEntity
        schedulesMap[dateKey] = SubscriptionScheduleEntity(
          id: booking.id,
          subscriptionId: '', // Empty for regular bookings
          tripDate: booking.bookingDate,
          tripType: booking.tripType,
          departureTime: booking.departureTime,
          returnTime: booking.returnTime,
          createdAt: booking.createdAt,
          updatedAt: booking.updatedAt,
        );
      }

      if (mounted) {
        setState(() {
          _schedules = schedulesMap;
        });
        _selectNearestTrip();
      }
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
    }
  }

  void _selectNearestTrip() {
    final now = DateTime.now();
    // Sort dates
    final sortedDates = _schedules.keys.toList()
      ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    // Find first date after now (or today if not passed yet)
    String? nearestDateKey;
    for (var dateKey in sortedDates) {
      final date = DateTime.parse(dateKey);
      // If date is today or future
      if (date.isAfter(now.subtract(const Duration(days: 1)))) {
        nearestDateKey = dateKey;
        break;
      }
    }

    // If found, select it
    if (nearestDateKey != null) {
      final date = DateTime.parse(nearestDateKey);
      final schedule = _schedules[nearestDateKey];
      setState(() {
        _selectedDate = date;
        if (schedule != null) {
          // _selectedTripType = schedule.tripType;
          _selectedDepartureTime = schedule.departureTime;
          _selectedReturnTime = schedule.returnTime;
        }
      });
    }
  }

  void _playSound() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  void _openFullScreenView() {
    _playSound();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenBookingView(
            initialDate: _selectedDate ?? DateTime.now(),
            schedules: _schedules,
            subscription: widget.subscription,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                final dateKey = date.toIso8601String().split('T')[0];
                final schedule = _schedules[dateKey];
                if (schedule != null) {
                  // _selectedTripType = schedule.tripType;
                  _selectedDepartureTime = schedule.departureTime;
                  _selectedReturnTime = schedule.returnTime;
                }
              });
            },
            onBookingTap: (booking) {
              Navigator.of(context).pop();
              // Just update the displayed details on the card
              setState(() {
                _selectedDate = booking.tripDate;
                // _selectedTripType = booking.tripType;
                _selectedDepartureTime = booking.departureTime;
                _selectedReturnTime = booking.returnTime;
              });
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Custom curve for realistic expansion
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          // Scale from card size to full screen
          final scaleAnimation = Tween<double>(
            begin: 0.85,
            end: 1.0,
          ).animate(curvedAnimation);

          // Slide up slightly for natural feel
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(curvedAnimation);

          return SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              alignment: Alignment.center,
              child: FadeTransition(opacity: animation, child: child),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        opaque: false,
        barrierColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _buildDetailsContent(),
        ),
      ),
    );
  }

  Widget _buildDetailsContent() {
    return GestureDetector(
      onTap: _openFullScreenView,
      onVerticalDragStart: (_) => _playSound(),
      onVerticalDragUpdate: (details) {
        setState(() {
          // Add resistance
          _dragOffsetY += details.primaryDelta! * 0.5;
        });
      },
      onVerticalDragEnd: (details) {
        // If dragged up significantly or flicked up
        if (_dragOffsetY < -80 || details.primaryVelocity! < -300) {
          _openFullScreenView();
          _runSpringBack();
        } else {
          _runSpringBack();
        }
      },
      child: Transform.translate(
        offset: Offset(0, _dragOffsetY),
        child: Padding(
          key: const ValueKey('details'),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'قريباً',
                      style: AppTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.2, end: 0),
              const SizedBox(height: 24),
              // Show selected booking data or subscription info
              if (_selectedDate != null) ...[
                // Times - Moved up as Date header is removed
                if (_selectedDepartureTime != null ||
                    _selectedReturnTime != null) ...[
                  Row(
                    children: [
                      if (_selectedDepartureTime != null) ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ميعاد الذهاب',
                                style: AppTheme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedDepartureTime!,
                                style: AppTheme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_selectedReturnTime != null) ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ميعاد العودة',
                                style: AppTheme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedReturnTime!,
                                style: AppTheme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
              const SizedBox(height: 24),
              // Start and End dates side by side
              Row(
                children: [
                  // Trip Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تاريخ الرحلة',
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d MMMM', 'ar').format(
                            _selectedDate ?? widget.subscription.startDate,
                          ),
                          style: AppTheme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              // Route Info with green arrow icon
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.arrow_right,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'من منطقتك إلى ${_universityName ?? "الجامعة"}',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  void _runSpringBack() {
    _springAnimation = Tween<double>(begin: _dragOffsetY, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );

    _springController.reset();
    _springController.forward();
    _springController.addListener(() {
      setState(() {
        _dragOffsetY = _springAnimation.value;
      });
    });
  }
}
