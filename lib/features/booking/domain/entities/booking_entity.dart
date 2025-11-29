import 'package:equatable/equatable.dart';

/// Booking status enumeration
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed;

  String toJson() => name;

  static BookingStatus fromJson(String value) {
    return BookingStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => BookingStatus.pending,
    );
  }
}

/// Payment status enumeration
enum PaymentStatus {
  unpaid,
  paid,
  refunded;

  String toJson() => name;

  static PaymentStatus fromJson(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}

/// Booking entity - represents a booking in the domain layer
class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String scheduleId;
  final DateTime bookingDate;
  final String tripType; // 'departure_only', 'return_only', 'round_trip'
  final String? pickupStationId;
  final String? dropoffStationId;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.bookingDate,
    required this.tripType,
    this.pickupStationId,
    this.dropoffStationId,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    scheduleId,
    bookingDate,
    tripType,
    pickupStationId,
    dropoffStationId,
    status,
    paymentStatus,
    totalPrice,
    createdAt,
    updatedAt,
  ];

  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
}
