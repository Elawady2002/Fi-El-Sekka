import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetUserBookingsUseCase {
  final BookingRepository _repository;

  GetUserBookingsUseCase(this._repository);

  Future<Either<Failure, List<BookingEntity>>> call() =>
      _repository.getUserBookings();
}
