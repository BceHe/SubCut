import 'package:flutter/material.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/settings/presentation/profile_screen.dart';
import 'features/subscriptions/presentation/detail_screen.dart';
import 'features/subscriptions/presentation/subscription_form_screen.dart';
import 'features/subscriptions/models/subscription.dart';
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case AppRoutes.dashboard:
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case AppRoutes.detail:
            final subscription = settings.arguments as Subscription;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(subscription: subscription),
            );
          case AppRoutes.subscriptionForm:
            return MaterialPageRoute(
              builder: (_) => SubscriptionFormScreen(
                subscription: settings.arguments as Subscription?,
              ),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}
