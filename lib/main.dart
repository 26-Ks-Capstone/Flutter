import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/palette.dart';
// [수정] SplashPage 임포트 (경로는 네 폴더 구조에 맞춰 확인해봐!)
import 'features/auth/ui/splash_page.dart';
import 'features/ai/ai_planner_provider.dart';
import 'features/auth/provider/auth_provider.dart';

void main() {
  // 앱 시작 전 바인딩 초기화 (보안 저장소 등 비동기 작업 대비)
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AIPlannerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const TravelPlannerApp(),
    ),
  );
}

class TravelPlannerApp extends StatelessWidget {
  const TravelPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 여행 플래너',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.primary,
          primary: Palette.primary,
          surface: Palette.background,
        ),
        scaffoldBackgroundColor: Palette.background,
        fontFamily: 'Pretendard',
      ),
      home: const SplashPage(),
    );
  }
}