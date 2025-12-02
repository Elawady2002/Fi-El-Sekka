import 'package:equatable/equatable.dart';

/// Subscription plan type enumeration
enum SubscriptionPlanType {
  monthly,
  semester;

  String toJson() => name;

  static SubscriptionPlanType fromJson(String value) {
    return SubscriptionPlanType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => SubscriptionPlanType.monthly,
    );
  }

  /// Get display name in Arabic
  String get displayName {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'باقة الشهر';
      case SubscriptionPlanType.semester:
        return 'باقة الترم';
    }
  }

  /// Get price for the plan
  double get price {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 600.0;
      case SubscriptionPlanType.semester:
        return 2000.0;
    }
  }

  /// Get duration in days
  int get durationDays {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 30;
      case SubscriptionPlanType.semester:
        return 120;
    }
  }
}

/// Subscription status enumeration
enum SubscriptionStatus {
  pending,
  active,
  expired;

  String toJson() => name;

  static SubscriptionStatus fromJson(String value) {
    return SubscriptionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SubscriptionStatus.pending,
    );
  }
}

/// Subscription entity - represents a user subscription
class SubscriptionEntity extends Equatable {
  final String userId;
  final SubscriptionPlanType planType;
  final double amount;
  final String? paymentProofUrl;
  final String? transferNumber;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  const SubscriptionEntity({
    required this.userId,
    required this.planType,
    required this.amount,
    this.paymentProofUrl,
    this.transferNumber,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    userId,
    planType,
    amount,
    paymentProofUrl,
    transferNumber,
    status,
    startDate,
    endDate,
    createdAt,
  ];

  /// Check if subscription is active
  bool get isActive =>
      status == SubscriptionStatus.active && endDate.isAfter(DateTime.now());

  /// Check if subscription is expired
  bool get isExpired => endDate.isBefore(DateTime.now());
}
