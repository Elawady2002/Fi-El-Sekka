import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../booking/domain/entities/city_entity.dart';
import '../../../booking/domain/entities/university_entity.dart';
import '../../../booking/domain/entities/boarding_station_entity.dart';
import '../../../booking/domain/entities/arrival_station_entity.dart';
import '../../../booking/domain/entities/route_entity.dart';
import '../../../booking/domain/entities/schedule_entity.dart';
import '../../../booking/domain/entities/university_boarding_point_entity.dart';
import '../../../booking/domain/entities/university_arrival_point_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CityEntity>>> getCities();
  Future<Either<Failure, List<UniversityEntity>>> getUniversities(
    String cityId,
  );
  Future<Either<Failure, List<BoardingStationEntity>>> getBoardingStations(
    String cityId,
  );
  Future<Either<Failure, List<ArrivalStationEntity>>> getArrivalStations(
    String pickupStationId,
  );
  Future<Either<Failure, List<RouteEntity>>> getRoutes(String universityId);
  Future<Either<Failure, List<ScheduleEntity>>> getSchedules(String routeId);
  Future<Either<Failure, List<BoardingStationEntity>>> getAllBoardingStations();
  Future<Either<Failure, List<ArrivalStationEntity>>> getAllArrivalStations();
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities();
  Future<Either<Failure, List<UniversityBoardingPointEntity>>> getUniversityBoardingPoints(String cityId);
  Future<Either<Failure, List<UniversityArrivalPointEntity>>> getUniversityArrivalPoints(String universityId);
}
