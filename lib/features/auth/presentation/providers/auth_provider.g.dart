// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authHash() => r'26a28099c075c73e66e3ff3756f93f7062a68a4c';

/// Authentication state provider
///
/// Copied from [Auth].
@ProviderFor(Auth)
final authProvider =
    AutoDisposeStreamNotifierProvider<Auth, UserEntity?>.internal(
      Auth.new,
      name: r'authProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Auth = AutoDisposeStreamNotifier<UserEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
