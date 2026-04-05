import '../entities/trip_type.dart';

/// Centralised trip pricing — change prices here without touching the domain enum.
class TripTypePricing {
  TripTypePricing._();

  static const Map<TripType, double> _prices = {
    TripType.departureOnly: 50.0,
    TripType.returnOnly: 50.0,
    TripType.roundTrip: 80.0,
  };

  static double priceOf(TripType type) => _prices[type] ?? 0.0;
}
