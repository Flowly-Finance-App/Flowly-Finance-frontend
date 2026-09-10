import 'dart:io';

enum IdentityDocType { aadhaar, pan, passport, drivingLicence }

/// Day 6 — KYC personal-details form state.
class KycFormState {
  final String name;
  final String dob;
  final String gender;
  final String mobile;
  final String email;
  final String city;
  final String address;

  const KycFormState({
    this.name = '',
    this.dob = '',
    this.gender = '',
    this.mobile = '',
    this.email = '',
    this.city = '',
    this.address = '',
  });

  KycFormState copyWith({
    String? name,
    String? dob,
    String? gender,
    String? mobile,
    String? email,
    String? city,
    String? address,
  }) {
    return KycFormState(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }
}

/// Day 7 — Document selection + upload state (Aadhaar/PAN/Passport/DL +
/// front/back/selfie images).
class DocumentUploadState {
  final IdentityDocType docType;
  final File? frontImage;
  final File? backImage;
  final File? selfieImage;
  final bool isUploaded;

  const DocumentUploadState({
    this.docType = IdentityDocType.aadhaar,
    this.frontImage,
    this.backImage,
    this.selfieImage,
    this.isUploaded = false,
  });

  bool get needsBackSide => docType != IdentityDocType.pan;

  DocumentUploadState copyWith({
    IdentityDocType? docType,
    File? frontImage,
    File? backImage,
    File? selfieImage,
    bool clearFront = false,
    bool clearBack = false,
    bool clearSelfie = false,
    bool? isUploaded,
  }) {
    return DocumentUploadState(
      docType: docType ?? this.docType,
      frontImage: clearFront ? null : (frontImage ?? this.frontImage),
      backImage: clearBack ? null : (backImage ?? this.backImage),
      selfieImage: clearSelfie ? null : (selfieImage ?? this.selfieImage),
      isUploaded: isUploaded ?? this.isUploaded,
    );
  }
}