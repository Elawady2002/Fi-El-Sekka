import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<Either<Failure, BookingEntity>> call({
    String? cityId,
    String? scheduleId,
    required DateTime bookingDate,
    required String tripType,
    String? pickupStationId,
    String? dropoffStationId,
    String? departureTime,
    String? returnTime,
    String? paymentProofImage,
    String? transferNumber,
    required double totalPrice,
    BookingSelectionType selectionType = BookingSelectionType.seat,
    int passengerCount = 1,
    bool splitPreference = true,
    bool isLadies = false,
  }) =>
      _repository.createBooking(
        cityId: cityId,
        scheduleId: scheduleId,
        bookingDate: bookingDate,
        tripType: tripType,
        pickupStationId: pickupStationId,
        dropoffStationId: dropoffStationId,
        departureTime: departureTime,
        returnTime: returnTime,
        paymentProofImage: paymentProofImage,
        transferNumber: transferNumber,
        totalPrice: totalPrice,
        selectionType: selectionType,
        passengerCount: passengerCount,
        splitPreference: splitPreference,
        isLadies: isLadies,
      );
}
