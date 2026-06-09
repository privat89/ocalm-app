import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/litiges_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const OcalmAdminApp());
}

class OcalmAdminApp extends StatelessWidget {
  const OcalmAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCALM Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AdminLoginScreen(),
        '/dashboard': (context) => const AdminDashboardScreen(),
        '/users': (context) => const AdminUsersScreen(),
        '/litiges': (context) => const AdminLitigesScreen(),
        '/transactions': (context) => const AdminTransactionsScreen(),
        '/settings': (context) => const AdminSettingsScreen(),
      },
    );
  }
}
