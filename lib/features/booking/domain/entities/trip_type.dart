enum TripType {
  departureOnly('ذهاب فقط', 50.0),
  returnOnly('عودة فقط', 50.0),
  roundTrip('ذهاب وعودة', 80.0);

  final String displayName;
  final double price;

  const TripType(this.displayName, this.price);

  /// Convert enum to database format (snake_case)
  String toDbValue() {
    switch (this) {
      case TripType.departureOnly:
        return 'departure_only';
      case TripType.returnOnly:
        return 'return_only';
      case TripType.roundTrip:
        return 'round_trip';
    }
  }
}
