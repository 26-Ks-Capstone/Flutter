import 'package:flutter/material.dart';
import '../../config/palette.dart';
import '../main/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0055FF), // 상단 배경색 (이미지 기준)
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
                      color: Colors.black.withValues(alpha: 0.2),
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainPage()),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 20),
                      label: const Text('로그인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
