import 'package:equatable/equatable.dart';

/// Route direction enumeration
enum RouteDirection {
  toUniversity('to_university'),
  fromUniversity('from_university');

  final String value;
  const RouteDirection(this.value);

  String toJson() => value;

  static RouteDirection fromJson(String value) {
    return RouteDirection.values.firstWhere(
      (direction) => direction.value == value,
      orElse: () => RouteDirection.toUniversity,
    );
  }
}

/// Schedule entity - represents a schedule for a route
class ScheduleEntity extends Equatable {
  final String id;
  final String routeId;
  final RouteDirection direction;
  final String departureTime; // Format: "HH:mm"
  final List<String> availableDays; // ['sunday', 'monday', ...]
  final int capacity;
  final double pricePerTrip;
  final bool isActive;

  const ScheduleEntity({
    required this.id,
    required this.routeId,
    required this.direction,
    required this.departureTime,
    required this.availableDays,
    required this.capacity,
    required this.pricePerTrip,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    routeId,
    direction,
    departureTime,
    availableDays,
    capacity,
    pricePerTrip,
    isActive,
  ];

  /// Check if schedule is available on a specific day
  bool isAvailableOn(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return availableDays.contains(dayName);
  }

  String _getDayName(int weekday) {
    // weekday: 1 = Monday, 7 = Sunday
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[(weekday - 1) % 7];
  }

  String get directionLabel =>
      direction == RouteDirection.toUniversity ? 'ذهاب' : 'عودة';
}
