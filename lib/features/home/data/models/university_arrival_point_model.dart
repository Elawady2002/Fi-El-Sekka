import '../../../booking/domain/entities/university_arrival_point_entity.dart';

class UniversityArrivalPointModel extends UniversityArrivalPointEntity {
  const UniversityArrivalPointModel({
    required super.id,
    required super.universityId,
    required super.nameAr,
    required super.nameEn,
  });

  factory UniversityArrivalPointModel.fromJson(Map<String, dynamic> json) {
    return UniversityArrivalPointModel(
      id: json['id'],
      universityId: json['university_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}
