import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/pages/dashboard_page.dart';
import 'package:shiharainu/pages/login_page.dart';
import 'package:shiharainu/pages/event_creation_page.dart';
import 'package:shiharainu/pages/payment_management_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shiharainu - イベント支払い管理',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  static final _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/event-creation',
        name: 'event-creation',
        builder: (context, state) => const EventCreationPage(),
      ),
      GoRoute(
        path: '/payment-management',
        name: 'payment-management',
        builder: (context, state) => const PaymentManagementPage(),
      ),
    ],
  );
}