import 'package:equatable/equatable.dart';

/// Route entity - represents a bus route
class RouteEntity extends Equatable {
  final String id;
  final String universityId;
  final String routeNameAr;
  final String routeNameEn;
  final String routeCode;
  final List<String> stationsOrder; // List of station IDs in order
  final bool isActive;

  const RouteEntity({
    required this.id,
    required this.universityId,
    required this.routeNameAr,
    required this.routeNameEn,
    required this.routeCode,
    required this.stationsOrder,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    universityId,
    routeNameAr,
    routeNameEn,
    routeCode,
    stationsOrder,
    isActive,
  ];

  String getLocalizedName(String languageCode) {
    return languageCode == 'ar' ? routeNameAr : routeNameEn;
  }
}
