import 'package:flutter/material.dart';
import '../../../core/storage/auth_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // 로그인 상태 업데이트 (로그인 성공 시 호출)
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  // [3번] 로그아웃 기능
  Future<void> logout() async {
    await AuthStorage.deleteToken(); // 1. 금고 비우기
    _isLoggedIn = false;             // 2. 상태 변경
    notifyListeners();               // 3. UI에 알림
  }
}