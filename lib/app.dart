import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff176b87),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfff7fafb),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xfff7fafb),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0xffe5eef0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffdce8eb)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffdce8eb)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xff176b87), width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        useMaterial3: true,
      ),
      // Local-first app: open directly to the active user's dashboard.
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: (settings) {
        switch (settings.name) {
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
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
        }
      },
    );
  }
}
