import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../../booking/domain/entities/city_entity.dart';
import '../../../booking/domain/entities/university_entity.dart';
import '../../../booking/domain/entities/station_entity.dart';
import '../../../booking/domain/entities/route_entity.dart';
import '../../../booking/domain/entities/schedule_entity.dart';

part 'home_provider.g.dart';

@riverpod
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  return HomeRemoteDataSourceImpl(Supabase.instance.client);
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource: remoteDataSource);
}

@riverpod
Future<List<CityEntity>> cities(CitiesRef ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getCities();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (cities) => cities,
  );
}

@riverpod
Future<List<UniversityEntity>> universities(
  UniversitiesRef ref,
  String cityId,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getUniversities(cityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (universities) => universities,
  );
}

@riverpod
Future<List<StationEntity>> stations(
  StationsRef ref,
  String universityId,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getStations(universityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stations) => stations,
  );
}

@riverpod
Future<List<RouteEntity>> routes(RoutesRef ref, String universityId) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getRoutes(universityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (routes) => routes,
  );
}

@riverpod
Future<List<ScheduleEntity>> schedules(SchedulesRef ref, String routeId) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getSchedules(routeId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (schedules) => schedules,
  );
}
