import 'package:flutter/material.dart';
import '../../core/storage/auth_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _userId;
  String? get userId => _userId;

  String? _nickname;
  String? get nickname => _nickname;

  bool _isGuide = false;
  bool get isGuide => _isGuide;

  bool _isGuideMode = false;
  bool get isGuideMode => _isGuideMode;

  void toggleGuideMode() {
    _isGuideMode = !_isGuideMode;
    notifyListeners();
  }

  // 💡 리턴 타입을 Future<bool>로 변경하여 UI단에서 성공 여부를 제어할 수 있게 합니다.
  Future<bool> login(Map<String, dynamic> authData) async {
    // 🔍 [디버깅 추가] 백엔드가 실제로 던져준 데이터 구조를 통째로 콘솔에 출력합니다.
    debugPrint('🔍 [AuthProvider] 들어온 raw authData: $authData');

    // 1. 토큰 추출 (다양한 후보군 키값 모두 매핑)
    final String? token = authData['accessToken'] ??
        authData['access_token'] ??
        authData['token']; // 💡 혹시 모를 'token' 키값 추가

    // 2. 유저 정보 추출
    final Map<String, dynamic>? userObj = authData['user'];

    final String? userId = (userObj != null
        ? (userObj['id'] ?? userObj['userId'])
        : (authData['user_id'] ?? authData['userId']))?.toString();

    final String? nickname = userObj != null ? userObj['nickname'] : authData['nickname'];

    final bool isGuide = (authData['is_guide'] ?? (userObj != null ? userObj['isGuide'] : false)) ?? false;

    // 🔍 [디버깅 추가] 파싱된 결과물 확인
    debugPrint('🔍 [AuthProvider] 파싱 결과 -> token 존재여부: ${token != null}, userId: $userId, nickname: $nickname');

    if (token == null || userId == null) {
      debugPrint('❌ [AuthProvider] 로그인 데이터 파싱 실패: 필수 정보가 누락되었습니다.');
      return false; // 💡 실패 시 false를 리턴하여 다음 화면으로 못 가게 막음
    }

    // 보안 저장소 및 메모리 상태 업데이트
    await AuthStorage.saveToken(token);
    await AuthStorage.saveUserData(
      userId: userId,
      nickname: nickname ?? '사용자',
      isGuide: isGuide,
    );

    _userId = userId;
    _nickname = nickname ?? '사용자';
    _isGuide = isGuide;
    _isLoggedIn = true;
    notifyListeners();

    return true; // 💡 최종 성공 시 true 반환
  }

  Future<void> loadAuthInfo() async {
    final token = await AuthStorage.getToken();
    if (token != null) {
      _userId = await AuthStorage.getUserId();
      _nickname = await AuthStorage.getNickname();
      _isGuide = await AuthStorage.isGuide();
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.deleteAuthData();
    _isLoggedIn = false;
    _userId = null;
    _nickname = null;
    _isGuide = false;
    _isGuideMode = false;
    notifyListeners();
  }
}