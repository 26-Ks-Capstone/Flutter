import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:capstone/config/palette.dart';
import '../main/main_page.dart';
import 'package:capstone/features/core/storage/auth_storage.dart';
import 'package:capstone/features/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // [수정] http 대신 통합 관리되는 DioClient 사용
      final response = await DioClient.instance.post(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        // 서버 DTO 구조에 맞춰 토큰 추출
        final String? token = responseData['data']['access_token'];

        if (token != null) {
          await AuthStorage.saveToken(token);
          print('🔑 JWT 저장 완료');
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;
      String message = '로그인 실패';
      if (e.response?.data != null && e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('에러 발생: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0055FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 헤더 섹션 (기존 유지)
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0066FF), Color(0xFF6600FF)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text('AI 여행 플래너', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('대화 한 번으로 완벽한 여행 일정을 만들어보세요', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            
            // 로그인 폼 섹션
            Container(
              decoration: const BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('로그인', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('계정에 로그인하여 여행을 시작하세요', style: TextStyle(color: Palette.mutedForeground, fontSize: 14)),
                  const SizedBox(height: 32),
                  const Text('이메일', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      filled: true,
                      fillColor: Palette.inputBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Palette.radius), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력하세요',
                      filled: true,
                      fillColor: Palette.inputBackground,
                      suffixIcon: const Icon(Icons.visibility_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Palette.radius), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleLogin,
                      icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(_isLoading ? '로그인 중...' : '로그인', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(text: '아직 계정이 없으신가요? '),
                          TextSpan(text: '회원가입', style: TextStyle(color: Color(0xFF0055FF), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
