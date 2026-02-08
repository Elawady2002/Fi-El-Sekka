// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionDataSourceHash() =>
    r'04e0aba5726739867015028daa9766585d456fc2';

/// See also [subscriptionDataSource].
@ProviderFor(subscriptionDataSource)
final subscriptionDataSourceProvider =
    AutoDisposeProvider<SubscriptionDataSource>.internal(
      subscriptionDataSource,
      name: r'subscriptionDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionDataSourceRef =
    AutoDisposeProviderRef<SubscriptionDataSource>;
String _$subscriptionRepositoryHash() =>
    r'27bedcb0dda880bd2682b4415a9d73b099c3184a';

/// See also [subscriptionRepository].
@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider =
    AutoDisposeProvider<SubscriptionRepository>.internal(
      subscriptionRepository,
      name: r'subscriptionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRepositoryRef =
    AutoDisposeProviderRef<SubscriptionRepository>;
String _$userSubscriptionsHash() => r'e136e55f8c698f33a6529ca9c1cf6f54a0bffeb7';

/// See also [userSubscriptions].
@ProviderFor(userSubscriptions)
final userSubscriptionsProvider =
    AutoDisposeFutureProvider<List<SubscriptionEntity>>.internal(
      userSubscriptions,
      name: r'userSubscriptionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSubscriptionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSubscriptionsRef =
    AutoDisposeFutureProviderRef<List<SubscriptionEntity>>;
String _$activeSubscriptionHash() =>
    r'27d9d0c6797ce34e9fa7e2683d99afc73609aa1e';

/// See also [activeSubscription].
@ProviderFor(activeSubscription)
final activeSubscriptionProvider =
    AutoDisposeFutureProvider<SubscriptionEntity?>.internal(
      activeSubscription,
      name: r'activeSubscriptionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeSubscriptionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveSubscriptionRef =
    AutoDisposeFutureProviderRef<SubscriptionEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
