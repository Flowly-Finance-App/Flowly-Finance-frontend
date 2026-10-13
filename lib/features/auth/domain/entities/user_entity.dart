class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String kycStatus;
  final bool isMpinSet;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.kycStatus,
    required this.isMpinSet,
    required this.isEmailVerified,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      kycStatus: json['kycStatus']?.toString() ?? '',
      isMpinSet: json['isMpinSet'] == true,
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }
}