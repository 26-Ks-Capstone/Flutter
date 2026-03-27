import 'package:dio/dio.dart';
import '../storage/auth_storage.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080', // 아까 정한 그 주소!
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      // [1번] 요청 인터셉터: 모든 API 호출 전 토큰 주입
      onRequest: (options, handler) async {
        final token = await AuthStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      // [2번] 에러 인터셉터: 401(만료) 발생 시 처리
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          print('토큰 만료! 로그아웃');
          await AuthStorage.deleteToken();
          // 여기서 로그인 페이지로 튕기는 로직은 Provider나 GlobalKey로 처리해!
        }
        return handler.next(e);
      },
    ));
    return _dio;
  }
}