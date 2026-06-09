import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminTransactionsScreen extends StatelessWidget {
  const AdminTransactionsScreen({super.key});

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
                    'Transactions',
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
                      child: const _TransactionsTable(),
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

class _TransactionsTable extends StatelessWidget {
  const _TransactionsTable();

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'id': '#TX-001', 'article': 'iPhone 15 Pro', 'montant': '750 000 F', 'acheteur': 'Kouassi', 'vendeur': 'Aminata', 'status': 'Complété'},
      {'id': '#TX-002', 'article': 'MacBook Air M2', 'montant': '650 000 F', 'acheteur': 'Yao', 'vendeur': 'Bamba', 'status': 'En escrow'},
      {'id': '#TX-003', 'article': 'Nike Air Max', 'montant': '45 000 F', 'acheteur': 'Kouamé', 'vendeur': 'Traoré', 'status': 'Livraison'},
      {'id': '#TX-004', 'article': 'Samsung S24', 'montant': '420 000 F', 'acheteur': 'Daniel', 'vendeur': 'Marie', 'status': 'En attente'},
    ];

    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Article')),
          DataColumn(label: Text('Montant')),
          DataColumn(label: Text('Acheteur')),
          DataColumn(label: Text('Vendeur')),
          DataColumn(label: Text('Statut')),
        ],
        rows: transactions.map((tx) {
          return DataRow(
            cells: [
              DataCell(Text(tx['id']!, style: const TextStyle(fontWeight: FontWeight.w500))),
              DataCell(Text(tx['article']!)),
              DataCell(Text(tx['montant']!, style: const TextStyle(fontWeight: FontWeight.w600))),
              DataCell(Text(tx['acheteur']!)),
              DataCell(Text(tx['vendeur']!)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: tx['status'] == 'Complété'
                        ? const Color(0xFF00D68F).withOpacity(0.1)
                        : tx['status'] == 'En escrow'
                            ? const Color(0xFF0066FF).withOpacity(0.1)
                            : const Color(0xFFFFB800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tx['status']!,
                    style: TextStyle(
                      color: tx['status'] == 'Complété'
                          ? const Color(0xFF00D68F)
                          : tx['status'] == 'En escrow'
                              ? const Color(0xFF0066FF)
                              : const Color(0xFFFFB800),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
