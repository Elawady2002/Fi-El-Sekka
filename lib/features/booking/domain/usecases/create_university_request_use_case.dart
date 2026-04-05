import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateUniversityRequestUseCase {
  final BookingRepository _repository;

  CreateUniversityRequestUseCase(this._repository);

  Future<Either<Failure, BookingEntity>> call({
    required DateTime bookingDate,
    required String universityId,
    String? cityId,
    String? routeId,
    String? uniBoardingPointId,
    String? uniArrivalPointId,
    required bool isCustomUniversity,
    String? customUniversityName,
    String? departureTime,
    String? returnTime,
    required double totalPrice,
    BookingSelectionType selectionType = BookingSelectionType.seat,
    int passengerCount = 1,
    bool splitPreference = true,
    bool isLadies = false,
  }) =>
      _repository.createUniversityRequest(
        bookingDate: bookingDate,
        universityId: universityId,
        cityId: cityId,
        routeId: routeId,
        uniBoardingPointId: uniBoardingPointId,
        uniArrivalPointId: uniArrivalPointId,
        isCustomUniversity: isCustomUniversity,
        customUniversityName: customUniversityName,
        departureTime: departureTime,
        returnTime: returnTime,
        totalPrice: totalPrice,
        selectionType: selectionType,
        passengerCount: passengerCount,
        splitPreference: splitPreference,
        isLadies: isLadies,
      );
}
