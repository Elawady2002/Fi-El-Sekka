import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class TransferBookingUseCase {
  final BookingRepository _repository;

  TransferBookingUseCase(this._repository);

  Future<Either<Failure, BookingEntity>> call({
    required String bookingId,
    String? targetUserId,
    String? targetPhoneNumber,
  }) =>
      _repository.transferBooking(
        bookingId: bookingId,
        targetUserId: targetUserId,
        targetPhoneNumber: targetPhoneNumber,
      );
}
