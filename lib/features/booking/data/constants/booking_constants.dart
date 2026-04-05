/// Database string constants for the bookings table.
/// Use these instead of raw string literals to prevent typos
/// and make future schema changes easier to track.
class BookingConstants {
  BookingConstants._();

  // Booking status values
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusExpired = 'expired';

  // Payment status values
  static const String paymentPaid = 'paid';
  static const String paymentUnpaid = 'unpaid';
  static const String paymentRefunded = 'refunded';

  // Route request status
  static const String routeRequestPending = 'pending';

  // Booking type flags
  static const String typeUniversityRequest = 'university_request';
}
