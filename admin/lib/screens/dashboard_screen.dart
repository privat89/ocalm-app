import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/stats_card.dart';
import '../widgets/chart_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      StatsCard(
                        title: 'Utilisateurs',
                        value: '1 847',
                        icon: Icons.people,
                        color: Color(0xFF0066FF),
                      ),
                      StatsCard(
                        title: 'Transactions/jour',
                        value: '342',
                        icon: Icons.swap_horiz,
                        color: Color(0xFF00B4D8),
                      ),
                      StatsCard(
                        title: 'Taux succès',
                        value: '98.2%',
                        icon: Icons.trending_up,
                        color: Color(0xFF00D68F),
                      ),
                      StatsCard(
                        title: 'Litiges ouverts',
                        value: '7',
                        icon: Icons.gavel,
                        color: Color(0xFFFF3D71),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Revenus plateforme',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '4 250 000 FCFA ce mois',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ChartBar(height: 0.6, label: 'Lun'),
                                ChartBar(height: 0.75, label: 'Mar'),
                                ChartBar(height: 0.45, label: 'Mer'),
                                ChartBar(height: 0.85, label: 'Jeu'),
                                ChartBar(height: 0.65, label: 'Ven'),
                                ChartBar(height: 0.9, label: 'Sam'),
                                ChartBar(height: 1.0, label: 'Dim', isMax: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
