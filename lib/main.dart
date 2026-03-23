import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/palette.dart';
import 'features/auth/login_page.dart';
import 'features/ai/ai_planner_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AIPlannerProvider()),
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
      home: const LoginPage(),
    );
  }
}
