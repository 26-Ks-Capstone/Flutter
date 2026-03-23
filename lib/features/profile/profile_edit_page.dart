import 'package:flutter/material.dart';
import '../../config/palette.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Palette.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(color: Palette.foreground, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('프로필 수정 페이지입니다.'),
      ),
    );
  }
}
