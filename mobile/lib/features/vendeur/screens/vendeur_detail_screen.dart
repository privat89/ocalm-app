import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_widgets.dart';

class VendeurDetailScreen extends StatelessWidget {
  final String acheteur;
  final String article;
  final int montant;
  final String reference;

  const VendeurDetailScreen({
    super.key,
    this.acheteur = 'Privat M.',
    this.article = 'Samsung Galaxy A14',
    this.montant = 35000,
    this.reference = 'OC-2025-00147',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: OcalmColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Détail de la vente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: OcalmColors.statusDelivered.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: OcalmColors.statusDelivered.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: OcalmColors.statusDelivered.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded, color: OcalmColors.statusDelivered, size: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Fonds sécurisés ✓',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SpaceGrotesk',
                      color: OcalmColors.statusDelivered,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'L\'acheteur a payé. Tu peux livrer en toute confiance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: OcalmColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: OcalmColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: OcalmColors.surfaceBorder, width: 0.5),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Article', value: article),
                  _divider(),
                  _DetailRow(label: 'Acheteur', value: acheteur),
                  _divider(),
                  _DetailRow(label: 'Montant', value: '$montant FCFA', isBold: true),
                  _divider(),
                  _DetailRow(label: 'Référence', value: reference),
                  _divider(),
                  _DetailRow(label: 'Frais vendeur', value: 'GRATUIT', valueColor: OcalmColors.statusDelivered),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // QR Code
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: OcalmColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: OcalmColors.surfaceBorder, width: 0.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'QR Code pour le livreur',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Le livreur scanne ce code au pickup',
                    style: TextStyle(fontSize: 12, color: OcalmColors.textHint),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: OcalmColors.textPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.qr_code_2_rounded, size: 120, color: OcalmColors.background),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_shipping_rounded, size: 18),
                    label: const Text('Faire livrer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.handshake_rounded, size: 18),
                    label: const Text('Remise main'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(height: 24, color: OcalmColors.divider.withOpacity(0.5));
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: OcalmColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            fontFamily: isBold ? 'SpaceGrotesk' : null,
            color: valueColor ?? OcalmColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
