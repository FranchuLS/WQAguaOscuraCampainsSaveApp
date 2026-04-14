import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/campaign_list_screen.dart';

void main() {
  runApp(const WQApp());
}

class WQApp extends StatelessWidget {
  const WQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WQ AguaOscura',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111418),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF111418)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B7FFF),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/campaigns': (context) => const CampaignListScreen(),
      },
    );
  }
}
