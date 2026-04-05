import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/booking_data_source.dart';

/// Provides [BookingDataSource] as an abstract type so consumers
/// depend on the interface, not the Supabase implementation.
final bookingDataSourceProvider = Provider<BookingDataSource>((ref) {
  return BookingDataSourceImpl();
});
