import 'package:flutter/material.dart';
import '../../config/palette.dart';
import '../../models/destination_model.dart';
import '../profile/profile_edit_page.dart';
import '../ai/ai_planner_page.dart';
import '../auth/login_page.dart';
import '../guide/ui/guide_explore_page.dart';
import '../guide/ui/guide_register_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _pages 변수를 제거하고 build 메서드 내에서 리스트를 직접 정의하여 초기화 에러를 원천 차단합니다.
    final List<Widget> pages = [
      _buildHomeScreen(),
      const AIPlannerPage(),
      const Center(child: Text('플래너 상세')),
    //  const Center(child: Text('가이드 화면')),
      const GuideExplorePage(),
      const GuideRegisterPage(),
      const Center(child: Text('마이 페이지')),
    ];

    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Palette.background,
        selectedItemColor: const Color(0xFF0055FF),
        unselectedItemColor: Palette.mutedForeground,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'AI 플래너',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: '플래너 상세',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: '가이드 탐색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note),
            label: '가이드 등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '마이',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    final sortedDestinations = List<Destination>.from(sampleDestinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    final topDestination = sortedDestinations.first;
    final popularDestinations = sortedDestinations.sublist(1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('어디로 떠나볼까요?', style: TextStyle(color: Palette.mutedForeground, fontSize: 14)),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Palette.foreground, fontSize: 24, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: '여행을 '),
                        TextSpan(text: '스마트', style: TextStyle(color: Color(0xFF0055FF))),
                        TextSpan(text: '하게'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Palette.mutedForeground, size: 22),
                    tooltip: '로그아웃',
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileEditPage()),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8866FF), Color(0xFF6600FF)],
                        ),
                      ),
                      child: const Center(
                        child: Text('J', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          InkWell(
            onTap: () => _onItemTapped(1),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Palette.inputBackground,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Palette.mutedForeground),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'AI에게 여행 일정을 물어보세요',
                      style: TextStyle(color: Palette.mutedForeground)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0055FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('추천 여행지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Palette.foreground)),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text('더보기', style: TextStyle(color: Palette.mutedForeground, fontSize: 12)),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Palette.mutedForeground),
                  ],
                ),
              ),
            ],
          ),
          _buildLargeCard(topDestination),

          const SizedBox(height: 30),

          const Text('인기 여행지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Palette.foreground)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: popularDestinations.length,
            itemBuilder: (context, index) {
              return _buildGridCard(popularDestinations[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLargeCard(Destination destination) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(destination.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(destination.location, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                Text(
                  destination.name,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('${destination.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    ...destination.tags.map((tag) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(Destination destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(destination.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(destination.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Palette.foreground)),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            const SizedBox(width: 4),
            Text('${destination.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Palette.foreground)),
          ],
        ),
      ],
    );
  }
}
