import 'package:equatable/equatable.dart';

class RouteRequestEntity extends Equatable {
  final String? id;
  final String userId;
  final String? cityId;
  final String boardingStationName;
  final String universityName;
  final String status;
  final DateTime createdAt;

  const RouteRequestEntity({
    this.id,
    required this.userId,
    this.cityId,
    required this.boardingStationName,
    required this.universityName,
    this.status = 'pending',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        cityId,
        boardingStationName,
        universityName,
        status,
        createdAt,
      ];
}
