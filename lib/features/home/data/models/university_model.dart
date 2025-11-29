import '../../../booking/domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  const UniversityModel({
    required super.id,
    required super.cityId,
    required super.nameAr,
    required super.nameEn,
    required super.location,
    required super.isActive,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as String,
      cityId: json['city_id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'location': location.toJson(),
      'is_active': isActive,
    };
  }
}
