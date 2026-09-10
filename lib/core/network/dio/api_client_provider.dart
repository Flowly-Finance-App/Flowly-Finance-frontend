import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NOTE: Ningal Day 1-il already oru ApiClient/Dio setup cheythittundenkil,
/// aa file-um provider-um thanne use cheyyuka — ithu oru fallback/reference
/// matram aanu, project-il ApiClient illenkil ith use cheyyam.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.yourapp.com', // TODO: replace with actual base URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});