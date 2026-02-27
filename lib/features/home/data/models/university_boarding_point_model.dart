import '../../../booking/domain/entities/university_boarding_point_entity.dart';


class UniversityBoardingPointModel extends UniversityBoardingPointEntity {
  const UniversityBoardingPointModel({
    required super.id,
    required super.cityId,
    required super.nameAr,
    required super.nameEn,
  });

  factory UniversityBoardingPointModel.fromJson(Map<String, dynamic> json) {
    return UniversityBoardingPointModel(
      id: json['id'],
      cityId: json['city_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}
