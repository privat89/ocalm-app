import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/role_selection_screen.dart';
import '../features/acheteur/screens/acheteur_home_screen.dart';
import '../features/acheteur/screens/nouvelle_transaction_screen.dart';
import '../features/acheteur/screens/detail_transaction_screen.dart';
import '../features/acheteur/screens/scan_qr_screen.dart';
import '../features/vendeur/screens/vendeur_home_screen.dart';
import '../features/vendeur/screens/vendeur_detail_screen.dart';
import '../features/livreur/screens/livreur_home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth flow
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/role-selection', builder: (_, __) => const RoleSelectionScreen()),

    // Acheteur
    GoRoute(path: '/acheteur', builder: (_, __) => const AcheteurHomeScreen()),
    GoRoute(path: '/acheteur/nouvelle-transaction', builder: (_, __) => const NouvelleTransactionScreen()),
    GoRoute(
      path: '/acheteur/transaction/:id',
      builder: (_, state) => DetailTransactionScreen(
        reference: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/acheteur/scan-qr/:ref',
      builder: (_, state) => ScanQRScreen(
        transactionRef: state.pathParameters['ref'] ?? '',
      ),
    ),

    // Vendeur
    GoRoute(path: '/vendeur', builder: (_, __) => const VendeurHomeScreen()),
    GoRoute(path: '/vendeur/detail/:id', builder: (_, __) => const VendeurDetailScreen()),

    // Livreur
    GoRoute(path: '/livreur', builder: (_, __) => const LivreurHomeScreen()),
  ],
);
