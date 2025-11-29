import 'package:equatable/equatable.dart';
import 'university_entity.dart';

/// Station type enumeration
enum StationType {
  pickup,
  dropoff,
  both;

  String toJson() => name;

  static StationType fromJson(String value) {
    return StationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => StationType.both,
    );
  }
}

/// Station entity - represents a pickup/dropoff station
class StationEntity extends Equatable {
  final String id;
  final String universityId;
  final String nameAr;
  final String nameEn;
  final Location location;
  final StationType stationType;
  final bool isActive;

  const StationEntity({
    required this.id,
    required this.universityId,
    required this.nameAr,
    required this.nameEn,
    required this.location,
    required this.stationType,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    universityId,
    nameAr,
    nameEn,
    location,
    stationType,
    isActive,
  ];

  String getLocalizedName(String languageCode) {
    return languageCode == 'ar' ? nameAr : nameEn;
  }

  bool get canPickup =>
      stationType == StationType.pickup || stationType == StationType.both;

  bool get canDropoff =>
      stationType == StationType.dropoff || stationType == StationType.both;
}
