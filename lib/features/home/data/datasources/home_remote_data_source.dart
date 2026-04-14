import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/city_model.dart';
import '../models/university_model.dart';
import '../models/boarding_station_model.dart';
import '../models/arrival_station_model.dart';
import '../models/route_model.dart';
import '../models/schedule_model.dart';
import '../models/university_boarding_point_model.dart';
import '../models/university_arrival_point_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CityModel>> getCities();
  Future<List<UniversityModel>> getUniversities(String cityId);
  Future<List<BoardingStationModel>> getBoardingStations(String cityId);
  Future<List<ArrivalStationModel>> getArrivalStations(String pickupStationId);
  Future<List<RouteModel>> getRoutes(String universityId);
  Future<List<BoardingStationModel>> getAllBoardingStations();
  Future<List<ArrivalStationModel>> getAllArrivalStations();
  Future<List<UniversityModel>> getAllUniversities();
  Future<List<ScheduleModel>> getSchedules(String routeId);
  Future<List<UniversityBoardingPointModel>> getUniversityBoardingPoints(String cityId);
  Future<List<UniversityArrivalPointModel>> getUniversityArrivalPoints(String universityId);
  Future<List<String>> getUniqueOrigins(String cityId);
  Future<List<String>> getAvailableDestinations(String originName, {String? cityId});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient _client;

  HomeRemoteDataSourceImpl(this._client);

  @override
  Future<List<CityModel>> getCities() async {
    final response = await _client
        .from('cities')
        .select()
        .eq('is_active', true)
        .order('name_ar');

    return response.map((e) => CityModel.fromJson(e)).toList();
  }

  @override
  Future<List<UniversityModel>> getUniversities(String cityId) async {
    final response = await _client
        .from('universities')
        .select()
        .eq('city_id', cityId)
        .eq('is_active', true)
        .order('name_ar');

    return response.map((e) => UniversityModel.fromJson(e)).toList();
  }

  @override
  Future<List<BoardingStationModel>> getBoardingStations(String cityId) async {
    final response = await _client
        .from('boarding_stations')
        .select()
        .eq('city_id', cityId)
        .order('name_ar');

    return response.map((e) => BoardingStationModel.fromJson(e)).toList();
  }

  @override
  Future<List<ArrivalStationModel>> getArrivalStations(String pickupStationId) async {
    final response = await _client
        .from('arrival_stations')
        .select()
        .eq('pickup_station_id', pickupStationId)
        .order('name_ar');

    return response.map((e) => ArrivalStationModel.fromJson(e)).toList();
  }

  @override
  Future<List<RouteModel>> getRoutes(String universityId) async {
    final response = await _client
        .from('routes')
        .select()
        .eq('university_id', universityId)
        .eq('is_active', true)
        .order('route_name_ar');

    return response.map((e) => RouteModel.fromJson(e)).toList();
  }

  @override
  Future<List<ScheduleModel>> getSchedules(String routeId) async {
    final response = await _client
        .from('trip_schedules')
        .select()
        .eq('route_id', routeId)
        .eq('is_active', true)
        .order('departure_time');

    return response.map((e) => ScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<List<BoardingStationModel>> getAllBoardingStations() async {
    final response = await _client
        .from('boarding_stations')
        .select()
        .order('name_ar');

    return response.map((e) => BoardingStationModel.fromJson(e)).toList();
  }

  @override
  Future<List<ArrivalStationModel>> getAllArrivalStations() async {
    final response = await _client
        .from('arrival_stations')
        .select()
        .order('name_ar');

    return response.map((e) => ArrivalStationModel.fromJson(e)).toList();
  }

  @override
  Future<List<UniversityModel>> getAllUniversities() async {
    final response = await _client
        .from('universities')
        .select()
        .eq('is_active', true)
        .order('name_ar');

    return response.map((e) => UniversityModel.fromJson(e)).toList();
  }

  @override
  Future<List<UniversityBoardingPointModel>> getUniversityBoardingPoints(String cityId) async {
    final response = await _client
        .from('university_boarding_points')
        .select()
        .eq('city_id', cityId)
        .order('name_ar');

    return response.map((e) => UniversityBoardingPointModel.fromJson(e)).toList();
  }

  @override
  Future<List<UniversityArrivalPointModel>> getUniversityArrivalPoints(String universityId) async {
    final response = await _client
        .from('university_arrival_points')
        .select()
        .eq('university_id', universityId)
        .order('name_ar');

    return response.map((e) => UniversityArrivalPointModel.fromJson(e)).toList();
  }

  @override
  Future<List<String>> getUniqueOrigins(String cityId) async {
    final response = await _client
        .from('trip_schedules')
        .select('origin')
        .eq('city_id', cityId)
        .eq('is_active', true);

    return (response as List)
        .where((e) => e['origin'] != null)
        .map((e) => (e['origin'] as String).trim())
        .toSet()
        .toList();
  }

  @override
  Future<List<String>> getAvailableDestinations(String originName, {String? cityId}) async {
    var query = _client
        .from('trip_schedules')
        .select('destination')
        .eq('origin', originName.trim())
        .eq('is_active', true);
    
    if (cityId != null) {
      query = query.eq('city_id', cityId);
    }

    final response = await query;

    final List<String> destinations = (response as List)
        .where((e) => e['destination'] != null)
        .map((e) => (e['destination'] as String).trim())
        .toSet() // Remove duplicates
        .toList();
    
    return destinations;
  }
}
