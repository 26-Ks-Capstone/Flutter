import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/config/palette.dart';
import 'package:capstone/features/auth/ui/splash_page.dart';
import 'package:capstone/features/ai/ai_planner_provider.dart';
import 'package:capstone/features/auth/provider/auth_provider.dart';
import 'package:capstone/features/guide/provider/guide_provider.dart';
import 'package:capstone/features/planner_detail/provider/planner_detail_provider.dart';
import 'package:capstone/features/planner_detail/provider/itinerary_detail_provider.dart';
import 'package:capstone/features/guider/provider/guide_registration_provider.dart'; // [추가]

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AIPlannerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GuideProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
        ChangeNotifierProvider(create: (_) => ItineraryDetailProvider()),
        ChangeNotifierProvider(create: (_) => GuideRegistrationProvider()), // [추가]
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
