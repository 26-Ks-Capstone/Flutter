import 'package:flutter/material.dart';
import '../../auth/login_page.dart';
import '../../guider/ui/guide_registration_page.dart'; // [수정] 새로운 가이드 등록 페이지 임포트
import 'app_settings_page.dart';
import 'liked_trips_page.dart';
import 'my_reviews_page.dart';
import 'notification_settings_page.dart';
import 'privacy_settings_page.dart';
import 'profile_edit_page.dart';
import 'support_page.dart';
import 'visited_trips_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String profileName = '김여행';
  String profileSubtitle = '여행을 사랑하는 탐험가';
  String profileId = '@qewr';
  String profileEmail = 'qewr@email.com';

  void _updateProfile({
    required String name,
    required String subtitle,
    required String id,
    required String email,
  }) {
    setState(() {
      profileName = name;
      profileSubtitle = subtitle;
      profileId = id;
      profileEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '마이페이지',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 28),
              _buildProfileCard(context),
              const SizedBox(height: 22),
              _buildLocalGuideBanner(context),
              const SizedBox(height: 26),
              const Text(
                '여행',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                children: [
                  _buildMenuRow(
                    icon: Icons.favorite_border,
                    title: '찜한 여행지',
                    trailingBadge: '3',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LikedTripsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.location_on_outlined,
                    title: '방문한 여행지',
                    trailingBadge: '12',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VisitedTripsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.star_border,
                    title: '내 리뷰',
                    trailingBadge: '5',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyReviewsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const Text(
                '설정',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                children: [
                  _buildMenuRow(
                    icon: Icons.notifications_none,
                    title: '알림 설정',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.shield_outlined,
                    title: '개인정보 보호',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacySettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.settings_outlined,
                    title: '앱 설정',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppSettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.help_outline,
                    title: '고객센터',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SupportPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                          (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFDECEC),
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FB),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B7CFF), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    profileName.isNotEmpty ? profileName[0] : 'J',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -4,
                bottom: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profileSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profileId,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () async {
                    final result = await Navigator.push<Map<String, String>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileEditPage(
                          initialName: profileName,
                          initialSubtitle: profileSubtitle,
                          initialId: profileId,
                          initialEmail: profileEmail,
                        ),
                      ),
                    );

                    if (result != null) {
                      _updateProfile(
                        name: result['name'] ?? profileName,
                        subtitle: result['subtitle'] ?? profileSubtitle,
                        id: result['id'] ?? profileId,
                        email: result['email'] ?? profileEmail,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    '프로필 수정',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalGuideBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // [수정] 새로운 가이드 등록 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const GuideRegistrationPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: const Color(0xFF09B45E),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -14,
              top: -8,
              child: Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 24,
              bottom: -34,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '로컬 가이드',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text(
                  '로컬 가이드로 등록하세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '당신만의 지역 지식을 여행자들과 나누고 수익을 만들어보세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    String? trailingBadge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (trailingBadge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  trailingBadge,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFB8C0CC),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFEEF1F5),
      ),
    );
  }
}
