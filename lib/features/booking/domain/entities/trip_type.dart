enum TripType {
  departureOnly('ذهاب فقط', 50.0),
  returnOnly('عودة فقط', 50.0),
  roundTrip('ذهاب وعودة', 80.0);

  final String displayName;
  final double price;

  const TripType(this.displayName, this.price);
}
