// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://api.flowlyfinance.com', // <- backend team tharunna real URL ivide
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {'Content-Type': 'application/json'},
//     ),
//   );
//   return dio;
// }); 


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://httpbin.org', // TEMPORARY — backend ready aayal real URL vekkuka
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});