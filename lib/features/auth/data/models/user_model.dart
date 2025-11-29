import '../../../../core/domain/entities/user_entity.dart';

/// User model - maps between Supabase JSON and UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.phone,
    required super.fullName,
    super.studentId,
    super.universityId,
    required super.userType,
    super.avatarUrl,
    required super.isVerified,
    required super.createdAt,
  });

  /// Create UserModel from Supabase JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      fullName: json['full_name'] as String,
      studentId: json['student_id'] as String?,
      universityId: json['university_id'] as String?,
      userType: UserType.fromJson(json['user_type'] as String),
      avatarUrl: json['avatar_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert UserModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'student_id': studentId,
      'university_id': universityId,
      'user_type': userType.toJson(),
      'avatar_url': avatarUrl,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      phone: entity.phone,
      fullName: entity.fullName,
      studentId: entity.studentId,
      universityId: entity.universityId,
      userType: entity.userType,
      avatarUrl: entity.avatarUrl,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phone: phone,
      fullName: fullName,
      studentId: studentId,
      universityId: universityId,
      userType: userType,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      createdAt: createdAt,
    );
  }
}
