class OnboardingState {
  final String fullName;
  final String email;
  final String phone;
  final String otp;
  final String dob;
  final String gender;
  final String address;
  final String idType;
  final String idNumber;
  final String documentUrl;
  final String mpin;

  const OnboardingState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.otp = '',
    this.dob = '',
    this.gender = '',
    this.address = '',
    this.idType = '',
    this.idNumber = '',
    this.documentUrl = '',
    this.mpin = '',
  });

  OnboardingState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? otp,
    String? dob,
    String? gender,
    String? address,
    String? idType,
    String? idNumber,
    String? documentUrl,
    String? mpin,
  }) {
    return OnboardingState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      documentUrl: documentUrl ?? this.documentUrl,
      mpin: mpin ?? this.mpin,
    );
  }

  Map<String, dynamic> toRegisterJson() {
    return {
      'fullName': fullName.trim(),
      'name': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'mobile': phone.trim(),
      'mpin': mpin.trim(),
      'otp': otp.trim(),
    };
  }

  Map<String, dynamic> toKycJson() {
    return {
      'dob': dob,
      'gender': gender,
      'address': address,
      'idType': idType,
      'idNumber': idNumber,
      'documentUrl': documentUrl,
    };
  }
}

typedef OnboardingEntity = OnboardingState;
