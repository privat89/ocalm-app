import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_widgets.dart';

class VendeurHomeScreen extends StatelessWidget {
  const VendeurHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes ventes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SpaceGrotesk',
                            color: OcalmColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vends tranquille, OCALM protège.',
                          style: TextStyle(fontSize: 13, color: OcalmColors.textHint),
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: OcalmColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: OcalmColors.surfaceBorder),
                      ),
                      child: const Center(
                        child: Icon(Icons.notifications_outlined, color: OcalmColors.textPrimary, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Revenue card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: OcalmColors.statusDelivered.withOpacity(0.3), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: OcalmColors.statusDelivered.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up_rounded, color: OcalmColors.statusDelivered, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Revenus ce mois',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '185 000 FCFA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _VendeurChip(label: '8 ventes', icon: Icons.shopping_bag_outlined),
                        const SizedBox(width: 12),
                        _VendeurChip(label: '4.8 ★', icon: Icons.star_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Nouvelles commandes
              OcalmWidgets.sectionHeader(title: 'Nouvelles commandes'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Fonds sécurisés — tu peux livrer',
                  style: TextStyle(fontSize: 12, color: OcalmColors.statusDelivered),
                ),
              ),
              const SizedBox(height: 12),

              _VenteCard(
                acheteur: 'Privat M.',
                article: 'Samsung Galaxy A14',
                montant: 35000,
                isNew: true,
                time: 'Il y a 10 min',
              ),
              const SizedBox(height: 8),
              _VenteCard(
                acheteur: 'Fatou B.',
                article: 'Écouteurs JBL',
                montant: 18000,
                isNew: true,
                time: 'Il y a 45 min',
              ),
              const SizedBox(height: 28),

              // En cours de livraison
              OcalmWidgets.sectionHeader(
                title: 'En livraison',
                actionLabel: 'Historique',
                onAction: () {},
              ),
              const SizedBox(height: 8),

              _VenteCard(
                acheteur: 'Kofi D.',
                article: 'Power Bank 20000mAh',
                montant: 12000,
                isNew: false,
                time: 'En livraison',
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: OcalmColors.backgroundDarker,
          border: Border(top: BorderSide(color: OcalmColors.surfaceBorder, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: OcalmColors.primary,
          unselectedItemColor: OcalmColors.textHint,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Ventes'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Historique'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_rounded), label: 'QR Code'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class _VendeurChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _VendeurChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _VenteCard extends StatelessWidget {
  final String acheteur;
  final String article;
  final int montant;
  final bool isNew;
  final String time;

  const _VenteCard({
    required this.acheteur,
    required this.article,
    required this.montant,
    required this.isNew,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OcalmColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNew ? OcalmColors.statusDelivered.withOpacity(0.3) : OcalmColors.surfaceBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isNew ? OcalmColors.statusDelivered : OcalmColors.statusInDelivery).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isNew ? Icons.lock_rounded : Icons.local_shipping_rounded,
                  color: isNew ? OcalmColors.statusDelivered : OcalmColors.statusInDelivery,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary)),
                    const SizedBox(height: 3),
                    Text('Acheteur: $acheteur', style: const TextStyle(fontSize: 12, color: OcalmColors.textHint)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${montant.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'SpaceGrotesk', color: OcalmColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(time, style: TextStyle(fontSize: 11, color: isNew ? OcalmColors.statusDelivered : OcalmColors.textHint)),
                ],
              ),
            ],
          ),
          if (isNew) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: OcalmColors.statusDelivered.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 16, color: OcalmColors.statusDelivered),
                        SizedBox(width: 6),
                        Text('Fonds sécurisés ✓', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.statusDelivered)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: OcalmColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: OcalmColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Text('Livrer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
