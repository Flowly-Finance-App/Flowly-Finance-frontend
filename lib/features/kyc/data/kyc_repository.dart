// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class KycRepository {
//   final Dio _dio;
//   KycRepository(this._dio);

//   Future<void> uploadDocument(File file, String side) async {
//     final formData = FormData.fromMap({
//       'side': side,
//       'file': await MultipartFile.fromFile(
//         file.path,
//         filename: file.path.split('/').last,
//       ),
//     });
//     await _dio.post('/kyc/upload-document', data: formData);
//   }

//   Future<void> submitKyc(Map<String, dynamic> payload) async {
//     await _dio.post('/kyc/submit', data: payload);
//   }

//   Future<String> fetchKycStatus() async {
//     final response = await _dio.get('/kyc/status');
//     return response.data['status'] ?? 'pending';
//   }
// }

// final kycRepositoryProvider = Provider<KycRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   return KycRepository(dio);
// });



import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class KycRepository {
  final Dio _dio;
  KycRepository(this._dio);

  /// API: POST /kyc/upload-document
  /// Multipart/form-data aayi Aadhaar/PAN image upload cheyyuka.
  ///
  /// TESTING: httpbin.org-il '/kyc/upload-document' ennoru real path illa,
  /// athukond temporary aayi '/anything/...' use cheyyunnu — httpbin ee
  /// path-ine accept cheythu ningal ayacha data echo cheythu tharum.
  /// Backend ready aayal ee line '/kyc/upload-document' aayi maattuka.
  Future<void> uploadDocument(File file, String side) async {
    final formData = FormData.fromMap({
      'side': side,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
    await _dio.post('/anything/kyc/upload-document', data: formData);
    // TODO backend ready aayal: await _dio.post('/kyc/upload-document', data: formData);
  }

  /// API: POST /kyc/submit
  Future<void> submitKyc(Map<String, dynamic> payload) async {
    await _dio.post('/anything/kyc/submit', data: payload);
    // TODO backend ready aayal: await _dio.post('/kyc/submit', data: payload);
  }

  /// API: GET /kyc/status
  ///
  /// TESTING: httpbin real 'status' field tharathathukond, temporary aayi
  /// 'approved' hardcode cheythirikkunnu — VerificationProgressScreen-inte
  /// full flow (approved-aayal Continue button varunnathu) test cheyyan.
  Future<String> fetchKycStatus() async {
    final response = await _dio.get('/anything/kyc/status');
    // TODO backend ready aayal: return response.data['status'] ?? 'pending';
    return response.statusCode == 200 ? 'approved' : 'pending';
  }
}

/// Repository-um athinte provider-um onnich — controller alla ithu,
/// ivide thanne vekkunnathu Riverpod-il common practice aanu.
final kycRepositoryProvider = Provider<KycRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return KycRepository(dio);
});