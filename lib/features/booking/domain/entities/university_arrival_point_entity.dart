import 'package:equatable/equatable.dart';

class UniversityArrivalPointEntity extends Equatable {
  final String id;
  final String universityId;
  final String nameAr;
  final String nameEn;

  const UniversityArrivalPointEntity({
    required this.id,
    required this.universityId,
    required this.nameAr,
    required this.nameEn,
  });

  @override
  List<Object?> get props => [id, universityId, nameAr, nameEn];
}
