import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/booking_model.dart';

abstract class BookingDataSource {
  Future<BookingModel> createBooking({
    required String userId,
    required String scheduleId,
    required DateTime bookingDate,
    required String tripType,
    String? pickupStationId,
    String? dropoffStationId,
    String? departureTime,
    String? returnTime,
    required double totalPrice,
  });

  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel?> getUpcomingBooking(String userId);
  Future<BookingModel> getBookingById(String bookingId);
}

class BookingDataSourceImpl implements BookingDataSource {
  SupabaseClient get _client => SupabaseConfig.client;

  @override
  Future<BookingModel> createBooking({
    required String userId,
    required String scheduleId,
    required DateTime bookingDate,
    required String tripType,
    String? pickupStationId,
    String? dropoffStationId,
    String? departureTime,
    String? returnTime,
    required double totalPrice,
  }) async {
    try {
      final now = DateTime.now();
      final response = await _client
          .from('bookings')
          .insert({
            'user_id': userId,
            'schedule_id': scheduleId,
            'booking_date': bookingDate.toIso8601String(),
            'trip_type': tripType,
            'pickup_station_id': pickupStationId,
            'dropoff_station_id': dropoffStationId,
            'departure_time': departureTime,
            'return_time': returnTime,
            'status': 'pending',
            'payment_status': 'unpaid',
            'total_price': totalPrice,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      return BookingModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during booking creation: $e');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final response = await _client
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('booking_date', ascending: false);

      return (response as List).map((e) => BookingModel.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching bookings: $e');
    }
  }

  @override
  Future<BookingModel?> getUpcomingBooking(String userId) async {
    try {
      final now = DateTime.now();
      // Use start of day to include trips scheduled for today
      final today = DateTime(now.year, now.month, now.day);

      final response = await _client
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .gte('booking_date', today.toIso8601String())
          .inFilter('status', ['pending', 'confirmed'])
          .order('booking_date', ascending: true)
          .limit(1);

      if (response.isEmpty) {
        return null;
      }

      return BookingModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching upcoming booking: $e');
    }
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      final response = await _client
          .from('bookings')
          .select()
          .eq('id', bookingId)
          .single();

      return BookingModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching booking: $e');
    }
  }
}
