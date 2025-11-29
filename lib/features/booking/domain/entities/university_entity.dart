import 'package:equatable/equatable.dart';

/// Location data class
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];

  Map<String, dynamic> toJson() {
    return {'lat': latitude, 'lng': longitude, 'address': address};
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
    );
  }
}

/// University entity - represents a university in the domain layer
class UniversityEntity extends Equatable {
  final String id;
  final String cityId;
  final String nameAr;
  final String nameEn;
  final Location location;
  final bool isActive;

  const UniversityEntity({
    required this.id,
    required this.cityId,
    required this.nameAr,
    required this.nameEn,
    required this.location,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, cityId, nameAr, nameEn, location, isActive];

  String getLocalizedName(String languageCode) {
    return languageCode == 'ar' ? nameAr : nameEn;
  }
}
