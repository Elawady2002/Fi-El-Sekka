import 'package:equatable/equatable.dart';

class UniversityBoardingPointEntity extends Equatable {
  final String id;
  final String cityId;
  final String nameAr;
  final String nameEn;

  const UniversityBoardingPointEntity({
    required this.id,
    required this.cityId,
    required this.nameAr,
    required this.nameEn,
  });

  @override
  List<Object?> get props => [id, cityId, nameAr, nameEn];
}
