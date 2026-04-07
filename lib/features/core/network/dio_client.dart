import 'dart:io';
import 'package:dio/dio.dart';
import '../storage/auth_storage.dart';

class DioClient {
  // 실기기 테스트를 위한 노트북 로컬 IP 설정
  static const String _laptopIp = '172.30.1.89';
  static const String _baseUrl = 'http://$_laptopIp:8080';

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 60), // AI 생성 대기 시간 고려
    contentType: 'application/json',
  ));

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('🚀 [DIO] Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        print('❌ [DIO] Error: Status ${e.response?.statusCode}');
        if (e.response?.statusCode == 401) {
          await AuthStorage.deleteToken();
        }
        return handler.next(e);
      },
    ));
    return _dio;
  }
}
