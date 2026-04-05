import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/booking_repository.dart';

class CreateRouteRequestUseCase {
  final BookingRepository _repository;

  CreateRouteRequestUseCase(this._repository);

  Future<Either<Failure, void>> call({
    String? cityId,
    String? cityName,
    required String boardingStationName,
    required String universityName,
  }) =>
      _repository.createRouteRequest(
        cityId: cityId,
        cityName: cityName,
        boardingStationName: boardingStationName,
        universityName: universityName,
      );
}
