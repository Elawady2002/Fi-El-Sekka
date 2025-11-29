import 'package:equatable/equatable.dart';

/// User type enumeration
enum UserType {
  student,
  driver,
  admin;

  String toJson() => name;

  static UserType fromJson(String value) {
    return UserType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserType.student,
    );
  }
}

/// User entity - represents a user in the domain layer
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String? studentId;
  final String? universityId;
  final UserType userType;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    this.studentId,
    this.universityId,
    required this.userType,
    this.avatarUrl,
    required this.isVerified,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    fullName,
    studentId,
    universityId,
    userType,
    avatarUrl,
    isVerified,
    createdAt,
  ];

  /// Check if user is a student
  bool get isStudent => userType == UserType.student;

  /// Check if user is a driver
  bool get isDriver => userType == UserType.driver;

  /// Check if user is an admin
  bool get isAdmin => userType == UserType.admin;

  /// Copy with method for immutability
  UserEntity copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    String? studentId,
    String? universityId,
    UserType? userType,
    String? avatarUrl,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      universityId: universityId ?? this.universityId,
      userType: userType ?? this.userType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
