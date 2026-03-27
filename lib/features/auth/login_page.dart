import 'dart:convert';
import 'dart:io'; // [추가] Platform 체크를 위해 필요
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // [추가]
import '../../config/palette.dart';
import '../main/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //JWT 저장 스토리지
  final storage = const FlutterSecureStorage();

  bool _isLoading = false;

  // [추가] 환경에 따른 서버 베이스 URL 설정
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // 안드로이드 에뮬레이터용
    } else {
      return 'http://localhost:8080'; // iOS 시뮬레이터용
    }
  }

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
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'), // [수정] 동적 URL 사용
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        //서버 응답 바디 파싱
        final responseData = jsonDecode(response.body);

        // 서버 DTO 구조: { "status": "success", "data": { "accessToken": "...", ... } }
        final String? token = responseData['data']['accessToken'];

        if (token != null) {
          // [핵심] JWT 토큰을 보안 저장소에 저장
          await storage.write(key: 'access_token', value: token);
          print('JWT 저장 완료: $token');
        }

        if (!mounted) return;

        // 로그인 성공 시 메인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // 로그인 실패 시 서버에서 보낸 에러 메시지 표시
        if (!mounted) return;
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? '로그인 정보를 확인해주세요.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 연결 실패. 서버가 켜져 있는지 확인하세요.\n$e')),
      );
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
            // 상단 헤더 섹션
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
                  const Text(
                    'AI 여행 플래너',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '대화 한 번으로 완벽한 여행 일정을 만들어보세요',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            // 로그인 폼 섹션
            Container(
              decoration: const BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '로그인',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '계정에 로그인하여 여행을 시작하세요',
                    style: TextStyle(color: Palette.mutedForeground, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  
                  // 이메일 입력
                  const Text('이메일', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      filled: true,
                      fillColor: Palette.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Palette.radius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 비밀번호 입력
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Palette.radius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleLogin,
                      icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(
                        _isLoading ? '로그인 중...' : '로그인', 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 구분선
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('또는', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 소셜 로그인 버튼들
                  _buildSocialButton(
                    context: context,
                    label: '카카오로 시작하기',
                    icon: Icons.chat_bubble,
                    color: const Color(0xFFFEE500),
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    context: context,
                    label: '네이버로 시작하기',
                    icon: Icons.text_snippet,
                    color: const Color(0xFF03C75A),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    context: context,
                    label: 'Google로 시작하기',
                    icon: Icons.g_mobiledata,
                    color: Palette.secondary,
                    textColor: Colors.black87,
                    isGoogle: true,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 회원가입 링크
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(text: '아직 계정이 없으신가요? '),
                          TextSpan(
                            text: '회원가입',
                            style: TextStyle(
                              color: Color(0xFF0055FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Widget _buildSocialButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    bool isGoogle = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        },
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: isGoogle ? const BorderSide(color: Palette.border) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
