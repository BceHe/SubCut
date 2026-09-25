import 'package:flutter/material.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/settings/presentation/profile_screen.dart';
import 'features/subscriptions/presentation/detail_screen.dart';
import 'routes/app_routes.dart';

class SubCutApp extends StatelessWidget {
  const SubCutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubCut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff176b87)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.detail: (_) => const DetailScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
    );
  }
}
