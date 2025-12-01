// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'15e2283fa88a68e9b3dac5bca55dff18874ff1a9';

/// See also [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider =
    AutoDisposeProvider<BookingRepository>.internal(
  bookingRepository,
  name: r'bookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRepositoryRef = AutoDisposeProviderRef<BookingRepository>;
String _$userBookingsHash() => r'fb5f1ff3981575d64a47c05afc67fd4e46285bfa';

/// See also [userBookings].
@ProviderFor(userBookings)
final userBookingsProvider =
    AutoDisposeFutureProvider<List<BookingEntity>>.internal(
  userBookings,
  name: r'userBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserBookingsRef = AutoDisposeFutureProviderRef<List<BookingEntity>>;
String _$upcomingBookingHash() => r'e21d3f2a47aa8104a018087a04e84b3ccb63381f';

/// See also [upcomingBooking].
@ProviderFor(upcomingBooking)
final upcomingBookingProvider =
    AutoDisposeFutureProvider<BookingEntity?>.internal(
  upcomingBooking,
  name: r'upcomingBookingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingBookingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpcomingBookingRef = AutoDisposeFutureProviderRef<BookingEntity?>;
String _$bookingStateHash() => r'8c20c0eced82b7291ec835f6cb04225c7a3a532a';

/// See also [BookingState].
@ProviderFor(BookingState)
final bookingStateProvider =
    AutoDisposeNotifierProvider<BookingState, BookingStateModel>.internal(
  BookingState.new,
  name: r'bookingStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookingState = AutoDisposeNotifier<BookingStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
