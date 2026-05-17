import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/config/palette.dart';
import 'package:capstone/features/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:capstone/features/auth/provider/auth_provider.dart';
import 'package:capstone/features/main/main_page.dart';

class GoogleSignUpPage extends StatefulWidget {
  final String email;
  final String? profileImageUrl;

  const GoogleSignUpPage({
    super.key,
    required this.email,
    this.profileImageUrl,
  });

  @override
  State<GoogleSignUpPage> createState() => _GoogleSignUpPageState();
}

class _GoogleSignUpPageState extends State<GoogleSignUpPage> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitAdditionalInfo() async {
    final String nickname = _nicknameController.text.trim();

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용하실 닉네임을 입력해주세요.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await DioClient.instance.post(
        '/api/v1/auth/google/register',
        data: {
          'email': widget.email,
          'nickname': nickname,
          'profileImageUrl': widget.profileImageUrl,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final authData = responseData['data'];

          // 🔍 [디버깅 추가] 회원가입 완료 후 백엔드가 돌려준 토큰 세션 데이터 구조를 확인합니다.
          debugPrint('🔍 [GoogleSignUpPage] 회원가입 완료 raw authData: $authData');

          if (!mounted) return;
          // 💡 [수정] 토큰 및 유저 세션 정보가 앱 내부에 완벽하게 파싱/저장(true)되었는지 검증합니다.
          final bool isSuccess = await context.read<AuthProvider>().login(authData);

          if (!mounted) return;
          if (isSuccess) {
            // 토큰이 세이브 공간에 완벽하게 안착했을 때만 메인 화면으로 진입시킵니다.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          } else {
            // 만약 true를 받지 못했다면 화면 이동을 막고 스낵바를 띄웁니다.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('회원가입 세션 생성에 실패했습니다. 유저 데이터를 확인하세요.')),
            );
          }
        }
      }
    } on DioException catch (e) {
      if (!mounted) return;
      String message = '회원가입 실패';
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

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: const Text('추가 정보 입력', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Palette.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: widget.profileImageUrl != null
                  ? NetworkImage(widget.profileImageUrl!)
                  : null,
              child: widget.profileImageUrl == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.email,
              style: const TextStyle(color: Palette.mutedForeground, fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '닉네임 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nicknameController,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: '앱에서 사용할 닉네임을 입력하세요',
                filled: true,
                fillColor: Palette.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAdditionalInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  '가입 완료하고 시작하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}