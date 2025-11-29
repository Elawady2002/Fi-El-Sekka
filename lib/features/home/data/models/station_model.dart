import '../../../booking/domain/entities/station_entity.dart';
import '../../../booking/domain/entities/university_entity.dart'; // For Location

class StationModel extends StationEntity {
  const StationModel({
    required super.id,
    required super.universityId,
    required super.nameAr,
    required super.nameEn,
    required super.location,
    required super.stationType,
    required super.isActive,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      stationType: StationType.fromJson(json['station_type'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'location': location.toJson(),
      'station_type': stationType.toJson(),
      'is_active': isActive,
    };
  }
}
