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

  // 로그인 성공 시 호출하여 상태 업데이트 및 저장
  Future<void> login(Map<String, dynamic> authData) async {
    final String userId = authData['user_id'];
    final String token = authData['access_token'];
    final String nickname = authData['nickname'];
    final bool isGuide = authData['is_guide'];

    await AuthStorage.saveToken(token);
    await AuthStorage.saveUserData(
      userId: userId,
      nickname: nickname,
      isGuide: isGuide,
    );

    _userId = userId;
    _nickname = nickname;
    _isGuide = isGuide;
    _isLoggedIn = true;
    notifyListeners();
  }

  // 앱 시작 시 저장된 정보 로드
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
    notifyListeners();
  }
}
