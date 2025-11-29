import '../../../booking/domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.universityId,
    required super.routeNameAr,
    required super.routeNameEn,
    required super.routeCode,
    required super.stationsOrder,
    required super.isActive,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      routeNameAr: json['route_name_ar'] as String,
      routeNameEn: json['route_name_en'] as String,
      routeCode: json['route_code'] as String,
      stationsOrder: List<String>.from(json['stations_order'] as List),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'route_name_ar': routeNameAr,
      'route_name_en': routeNameEn,
      'route_code': routeCode,
      'stations_order': stationsOrder,
      'is_active': isActive,
    };
  }
}
