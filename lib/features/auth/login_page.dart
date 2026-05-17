import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/config/palette.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 💡 구글 로고용 SVG 패키지 임포트
import '../main/main_page.dart';
import 'provider/auth_provider.dart';
import 'package:capstone/features/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'signup_page.dart';
import 'ui/google_signup_page.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
  }

  Future<void> _initGoogleSignIn() async {
    await GoogleSignIn.instance.initialize(
      clientId: Platform.isIOS
          ? '275653224499-7l4pv159esnl7oe41dlv2b0l0pukn571.apps.googleusercontent.com'
          : null,
      serverClientId: '275653224499-v4p4mheg008rq9b8ac538eraceaqmfis.apps.googleusercontent.com',
    );
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

    setState(() => _isLoading = true);

    try {
      final response = await DioClient.instance.post(
        '/api/v1/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final authData = responseData['data'];

          if (!mounted) return;
          final bool isSuccess = await context.read<AuthProvider>().login(authData);

          if (!mounted) return;
          if (isSuccess) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('로그인 세션 생성에 실패했습니다. 유저 데이터를 확인하세요.')),
            );
          }
        }
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google ID Token을 가져올 수 없습니다.');
      }

      final response = await DioClient.instance.post(
        '/api/v1/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final authData = responseData['data'];
          final bool isNewUser = authData['isNewUser'] ?? authData['newUser'] ?? false;

          if (!mounted) return;

          if (isNewUser) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => GoogleSignUpPage(
                  email: authData['email'] ?? googleUser.email,
                  profileImageUrl: authData['profileImageUrl'] ?? googleUser.photoUrl,
                ),
              ),
            );
          } else {
            final bool isSuccess = await context.read<AuthProvider>().login(authData);

            if (!mounted) return;
            if (isSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('구글 인증 세션 생성에 실패했습니다. 백엔드 DTO 규격을 확인하세요.')),
              );
            }
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      if (e is GoogleSignInException && e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google 로그인 실패: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      backgroundColor: Palette.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
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
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle
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
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
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
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        filled: true,
                        fillColor: Palette.inputBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
                    const SizedBox(height: 24),
                    const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('또는', style: TextStyle(color: Colors.grey, fontSize: 12))), Expanded(child: Divider())]),
                    const SizedBox(height: 24),

                    // 카카오 로그인 (공식 노란색 적용 + 테두리 절대 없음)
                    _buildSocialButton(
                        label: '카카오로 시작하기',
                        imageAssetPath: 'assets/icons/kakao/kakao_logo.png',
                        color: const Color(0xFFFEE500),
                        textColor: const Color(0xFF3C1E1E),
                        onPressed: () {}
                    ),
                    const SizedBox(height: 12),

                    // 구글 로그인 (💡 색상을 원래 쓰던 Palette.secondary로 원상 복구!)
                    _buildSocialButton(
                        label: 'Google로 시작하기',
                        imageAssetPath: 'assets/icons/google/google_logo.svg',
                        color: Palette.secondary, // 원래 색깔로 롤백!
                        textColor: Colors.black87,
                        onPressed: _handleGoogleLogin
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(text: '아직 계정이 없으신가요? '),
                              TextSpan(
                                text: '회원가입',
                                style: TextStyle(color: Color(0xFF0055FF), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 💡 테두리를 100% 제거하기 위해 완전히 면(Surface) 기반인 ElevatedButton으로 변경
  Widget _buildSocialButton({
    required String label,
    String? imageAssetPath,
    IconData? icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0, // 🛠️ 버튼 그림자 완전 제거
          shadowColor: Colors.transparent, // 🛠️ 잔상 그림자까지 투명화하여 테두리와 요철을 원천 차단
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          children: [
            if (imageAssetPath != null)
              imageAssetPath.endsWith('.svg')
                  ? SvgPicture.asset(imageAssetPath, width: 22, height: 22)
                  : Image.asset(imageAssetPath, width: 22, height: 22)
            else if (icon != null)
              Icon(icon, color: textColor, size: 22),

            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),

            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}