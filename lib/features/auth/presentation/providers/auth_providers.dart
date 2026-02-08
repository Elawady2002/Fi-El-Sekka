import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/supabase_auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Data Source Provider
final authDataSourceProvider = Provider<SupabaseAuthDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(supabaseClient);
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});
