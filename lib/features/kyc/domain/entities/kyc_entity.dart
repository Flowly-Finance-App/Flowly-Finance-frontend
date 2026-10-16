import 'dart:io';

enum IdentityDocType { aadhaar, pan, passport, drivingLicence }

class KycFormState {
  final String name;
  final String dob;
  final String gender;
  final String mobile;
  final String email;
  final String city;
  final String address;
  final String idNumber;
  final String panNumber;

  const KycFormState({
    this.name = '',
    this.dob = '',
    this.gender = '',
    this.mobile = '',
    this.email = '',
    this.city = '',
    this.address = '',
    this.idNumber = '',
    this.panNumber = '',
  });

  KycFormState copyWith({
    String? name,
    String? dob,
    String? gender,
    String? mobile,
    String? email,
    String? city,
    String? address,
    String? idNumber,
    String? panNumber,
  }) {
    return KycFormState(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city ?? this.city,
      address: address ?? this.address,
      idNumber: idNumber ?? this.idNumber,
      panNumber: panNumber ?? this.panNumber,
    );
  }
}

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