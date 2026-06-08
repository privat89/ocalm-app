import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Exporter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: OcalmColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Stats row
            Row(
              children: [
                _StatCard(label: 'Total', value: '1 247', icon: Icons.people, color: OcalmColors.primary),
                const SizedBox(width: 12),
                _StatCard(label: 'Acheteurs', value: '832', icon: Icons.shopping_bag_outlined, color: OcalmColors.success),
                const SizedBox(width: 12),
                _StatCard(label: 'Vendeurs', value: '356', icon: Icons.storefront_outlined, color: const Color(0xFFFF9900)),
                const SizedBox(width: 12),
                _StatCard(label: 'Livreurs', value: '59', icon: Icons.delivery_dining, color: OcalmColors.primary),
                const SizedBox(width: 12),
                _StatCard(label: 'Bloqués', value: '4', icon: Icons.block, color: OcalmColors.statusDispute),
              ],
            ),
            const SizedBox(height: 20),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, téléphone ou ID...',
                prefixIcon: const Icon(Icons.search, color: OcalmColors.textHint),
                filled: true,
                fillColor: OcalmColors.backgroundCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: OcalmColors.divider)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: OcalmColors.divider)),
              ),
            ),
            const SizedBox(height: 16),

            // Users table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: OcalmColors.backgroundCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: OcalmColors.divider),
                ),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: OcalmColors.backgroundGrey,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 150, child: Text('Nom', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          SizedBox(width: 130, child: Text('Téléphone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          SizedBox(width: 90, child: Text('Rôle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          SizedBox(width: 60, child: Text('Tx', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          SizedBox(width: 60, child: Text('Note', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          Expanded(child: Text('Statut', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                          SizedBox(width: 80, child: Text('Actions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textHint))),
                        ],
                      ),
                    ),
                    // Table rows
                    Expanded(
                      child: ListView(
                        children: const [
                          _UserRow(name: 'Privat M.', phone: '+225 07 12 34 56', role: 'acheteur', transactions: 12, rating: 4.8, isActive: true, isVerified: true),
                          _UserRow(name: 'Moussa K.', phone: '+225 05 98 76 54', role: 'vendeur', transactions: 45, rating: 4.6, isActive: true, isVerified: true),
                          _UserRow(name: 'Koné A.', phone: '+225 01 23 45 67', role: 'livreur', transactions: 89, rating: 4.9, isActive: true, isVerified: true),
                          _UserRow(name: 'Fatou B.', phone: '+225 07 11 22 33', role: 'acheteur', transactions: 3, rating: 5.0, isActive: true, isVerified: true),
                          _UserRow(name: 'Ibrahim T.', phone: '+225 05 44 55 66', role: 'vendeur', transactions: 28, rating: 3.2, isActive: false, isVerified: true),
                          _UserRow(name: 'Awa S.', phone: '+225 07 77 88 99', role: 'acheteur', transactions: 7, rating: 4.5, isActive: true, isVerified: true),
                          _UserRow(name: 'Jean-Marc L.', phone: '+225 01 00 11 22', role: 'vendeur', transactions: 15, rating: 2.1, isActive: false, isVerified: false),
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: OcalmColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OcalmColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: OcalmColors.textPrimary)),
                Text(label, style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  final String name;
  final String phone;
  final String role;
  final int transactions;
  final double rating;
  final bool isActive;
  final bool isVerified;

  const _UserRow({
    required this.name,
    required this.phone,
    required this.role,
    required this.transactions,
    required this.rating,
    required this.isActive,
    required this.isVerified,
  });

  Color get _roleColor {
    switch (role) {
      case 'acheteur': return OcalmColors.primary;
      case 'vendeur': return OcalmColors.success;
      case 'livreur': return const Color(0xFFFF9900);
      default: return OcalmColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: OcalmColors.divider.withOpacity(0.5)))),
      child: Row(
        children: [
          SizedBox(width: 150, child: Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: _roleColor.withOpacity(0.1), child: Text(name[0], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _roleColor))),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: OcalmColors.textPrimary)),
            ],
          )),
          SizedBox(width: 130, child: Text(phone, style: const TextStyle(fontSize: 12, color: OcalmColors.textSecondary))),
          SizedBox(width: 90, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: _roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(role, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _roleColor)),
          )),
          SizedBox(width: 60, child: Text('$transactions', style: const TextStyle(fontSize: 13, color: OcalmColors.textPrimary))),
          SizedBox(width: 60, child: Row(
            children: [
              const Icon(Icons.star, size: 12, color: Color(0xFFFFB800)),
              const SizedBox(width: 2),
              Text('$rating', style: const TextStyle(fontSize: 12, color: OcalmColors.textPrimary)),
            ],
          )),
          Expanded(child: Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? OcalmColors.success : OcalmColors.statusDispute)),
              const SizedBox(width: 6),
              Text(isActive ? 'Actif' : 'Bloqué', style: TextStyle(fontSize: 12, color: isActive ? OcalmColors.success : OcalmColors.statusDispute)),
            ],
          )),
          SizedBox(width: 80, child: Row(
            children: [
              IconButton(icon: const Icon(Icons.visibility_outlined, size: 16), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 30)),
              IconButton(icon: Icon(isActive ? Icons.block : Icons.check_circle_outline, size: 16, color: isActive ? OcalmColors.statusDispute : OcalmColors.success), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 30)),
            ],
          )),
        ],
      ),
    );
  }
}
