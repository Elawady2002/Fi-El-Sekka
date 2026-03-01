import '../../../booking/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.isActive,
    super.hasPointToPoint = true,
    super.hasUniversityService = false,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      isActive: json['is_active'] as bool? ?? true,
      hasPointToPoint: json['has_point_to_point'] as bool? ?? true,
      hasUniversityService: json['has_university_service'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'is_active': isActive,
      'has_point_to_point': hasPointToPoint,
      'has_university_service': hasUniversityService,
    };
  }
}
