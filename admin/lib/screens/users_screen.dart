import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

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
                    'Utilisateurs',
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher un utilisateur...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0066FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const _UsersTable(),
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

class _UsersTable extends StatelessWidget {
  const _UsersTable();

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Kouassi Jean', 'phone': '+225 07 12 34 56', 'role': 'Acheteur', 'status': 'Actif'},
      {'name': 'Traoré Aminata', 'phone': '+225 07 89 45 12', 'role': 'Vendeur', 'status': 'Actif'},
      {'name': 'Kouamé Daniel', 'phone': '+225 07 56 78 90', 'role': 'Livreur', 'status': 'En attente'},
      {'name': 'Yao Marie', 'phone': '+225 07 34 67 89', 'role': 'Acheteur', 'status': 'Actif'},
      {'name': 'Bamba Kofi', 'phone': '+225 07 90 12 34', 'role': 'Vendeur', 'status': 'Bloqué'},
    ];

    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Téléphone')),
            DataColumn(label: Text('Rôle')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Actions')),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user['name']!)),
                DataCell(Text(user['phone']!)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user['role']!,
                      style: const TextStyle(
                        color: Color(0xFF0066FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: user['status'] == 'Actif'
                          ? const Color(0xFF00D68F).withOpacity(0.1)
                          : user['status'] == 'Bloqué'
                              ? const Color(0xFFFF3D71).withOpacity(0.1)
                              : const Color(0xFFFFB800).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user['status']!,
                      style: TextStyle(
                        color: user['status'] == 'Actif'
                            ? const Color(0xFF00D68F)
                            : user['status'] == 'Bloqué'
                                ? const Color(0xFFFF3D71)
                                : const Color(0xFFFFB800),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.block, size: 20, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
