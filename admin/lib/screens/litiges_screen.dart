import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminLitigesScreen extends StatelessWidget {
  const AdminLitigesScreen({super.key});

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
                    'Litiges',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const _LitigesList(),
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

class _LitigesList extends StatelessWidget {
  const _LitigesList();

  @override
  Widget build(BuildContext context) {
    final litiges = [
      {
        'id': '#LIT-001',
        'parties': 'Kouamé vs Traoré',
        'montant': '185 000 F',
        'raison': 'Article non conforme',
        'status': 'En cours',
        'date': '09/06/2026',
      },
      {
        'id': '#LIT-002',
        'parties': 'Yao vs Bamba',
        'montant': '420 000 F',
        'raison': 'Livraison non reçue',
        'status': 'En attente',
        'date': '08/06/2026',
      },
      {
        'id': '#LIT-003',
        'parties': 'Kouassi vs Aminata',
        'montant': '75 000 F',
        'raison': 'Remboursement demandé',
        'status': 'Résolu',
        'date': '05/06/2026',
      },
    ];

    return ListView.separated(
      itemCount: litiges.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final litige = litiges[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: litige['status'] == 'En cours'
                ? const Color(0xFFFF3D71).withOpacity(0.1)
                : litige['status'] == 'En attente'
                    ? const Color(0xFFFFB800).withOpacity(0.1)
                    : const Color(0xFF00D68F).withOpacity(0.1),
            child: Icon(
              Icons.gavel,
              color: litige['status'] == 'En cours'
                  ? const Color(0xFFFF3D71)
                  : litige['status'] == 'En attente'
                      ? const Color(0xFFFFB800)
                      : const Color(0xFF00D68F),
            ),
          ),
          title: Text(
            '${litige['id']} - ${litige['parties']}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${litige['raison']} - ${litige['montant']}'),
              Text('${litige['date']}'),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: litige['status'] == 'En cours'
                  ? const Color(0xFFFF3D71).withOpacity(0.1)
                  : litige['status'] == 'En attente'
                      ? const Color(0xFFFFB800).withOpacity(0.1)
                      : const Color(0xFF00D68F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              litige['status']!,
              style: TextStyle(
                color: litige['status'] == 'En cours'
                    ? const Color(0xFFFF3D71)
                    : litige['status'] == 'En attente'
                        ? const Color(0xFFFFB800)
                        : const Color(0xFF00D68F),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}
