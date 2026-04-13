import 'package:flutter/material.dart';
import 'package:wqaguaoscura_app/screens/campaign_list_screen.dart';

class WQApp extends StatelessWidget {
  const WQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WQ Agua Oscura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CampaignListScreen(),
    );
  }
}