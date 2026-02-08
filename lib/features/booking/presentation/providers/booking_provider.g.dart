// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'665eef1adabaecdb9a5a1798f4298917e894b90f';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingRepositoryRef = AutoDisposeProviderRef<BookingRepository>;
String _$userBookingsHash() => r'5365a8677cb2ae527af4f21d5439094e9e19e958';

/// See also [userBookings].
@ProviderFor(userBookings)
final userBookingsProvider =
    AutoDisposeFutureProvider<List<BookingEntity>>.internal(
      userBookings,
      name: r'userBookingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userBookingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserBookingsRef = AutoDisposeFutureProviderRef<List<BookingEntity>>;
String _$upcomingBookingHash() => r'384f7216a1f768b1ccdd56190bc8fb0716e69053';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingBookingRef = AutoDisposeFutureProviderRef<BookingEntity?>;
String _$bookingStateHash() => r'a0df8a590073154399e459dc581ac96af02ff3e9';

/// See also [BookingState].
@ProviderFor(BookingState)
final bookingStateProvider =
    AutoDisposeNotifierProvider<BookingState, BookingStateModel>.internal(
      BookingState.new,
      name: r'bookingStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookingState = AutoDisposeNotifier<BookingStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
