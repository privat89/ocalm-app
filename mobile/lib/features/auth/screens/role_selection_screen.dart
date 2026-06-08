import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/constants/ocalm_constants.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const Text(
                'Comment tu utilises\nOCALM ?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: OcalmColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu pourras changer de rôle plus tard.',
                style: TextStyle(
                  fontSize: 15,
                  color: OcalmColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // Role cards
              _RoleCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Acheteur',
                description:
                    'J\'achète sur Marketplace ou WhatsApp et je veux que mon argent soit protégé.',
                color: OcalmColors.primary,
                onTap: () {
                  // TODO: Set role & navigate to acheteur home
                },
              ),
              const SizedBox(height: 16),

              _RoleCard(
                icon: Icons.storefront_outlined,
                title: 'Vendeur',
                description:
                    'Je vends des articles et je veux être payé à coup sûr après livraison.',
                color: OcalmColors.success,
                onTap: () {
                  // TODO: Set role & navigate to vendeur home
                },
              ),
              const SizedBox(height: 16),

              _RoleCard(
                icon: Icons.delivery_dining_outlined,
                title: 'Livreur',
                description:
                    'Je livre des colis et je veux être payé automatiquement à chaque course.',
                color: const Color(0xFFFF9900),
                onTap: () {
                  // TODO: Set role & navigate to livreur home
                },
              ),

              const Spacer(),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OcalmColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: OcalmColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Un même compte peut être acheteur ET vendeur. Le rôle livreur nécessite une vérification d\'identité.',
                        style: TextStyle(
                          fontSize: 12,
                          color: OcalmColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: OcalmColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OcalmColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: OcalmColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: OcalmColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: OcalmColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
