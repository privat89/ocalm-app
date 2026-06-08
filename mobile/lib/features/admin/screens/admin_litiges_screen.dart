import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';

class AdminLitigesScreen extends StatelessWidget {
  const AdminLitigesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Gestion des litiges'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OcalmColors.statusDispute.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: OcalmColors.statusDispute)),
                const SizedBox(width: 6),
                const Text('3 actifs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.statusDispute)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Filters
          Row(
            children: [
              _FilterChip(label: 'Tous', isActive: true),
              const SizedBox(width: 8),
              _FilterChip(label: 'Ouverts', isActive: false),
              const SizedBox(width: 8),
              _FilterChip(label: 'En médiation', isActive: false),
              const SizedBox(width: 8),
              _FilterChip(label: 'Résolus', isActive: false),
            ],
          ),
          const SizedBox(height: 20),

          // Litige cards
          _LitigeCard(
            reference: 'OC-2025-00148',
            acheteur: 'Mamadou C.',
            vendeur: 'Privat M.',
            montant: 8000,
            raison: 'Article non conforme à la description',
            status: 'ouvert',
            since: '2 heures',
            messagesCount: 3,
            hasEvidence: true,
          ),
          const SizedBox(height: 12),
          _LitigeCard(
            reference: 'OC-2025-00139',
            acheteur: 'Awa S.',
            vendeur: 'Jean-Marc L.',
            montant: 45000,
            raison: 'Article non reçu malgré confirmation livreur',
            status: 'en_mediation',
            since: '1 jour',
            messagesCount: 8,
            hasEvidence: true,
          ),
          const SizedBox(height: 12),
          _LitigeCard(
            reference: 'OC-2025-00131',
            acheteur: 'Kofi D.',
            vendeur: 'Aminata D.',
            montant: 22000,
            raison: 'Colis endommagé à la réception',
            status: 'ouvert',
            since: '3 jours',
            messagesCount: 5,
            hasEvidence: false,
          ),
          const SizedBox(height: 12),
          _LitigeCard(
            reference: 'OC-2025-00125',
            acheteur: 'Fatou B.',
            vendeur: 'Ibrahim T.',
            montant: 15000,
            raison: 'Vendeur ne répond plus après paiement',
            status: 'resolu',
            since: '5 jours',
            messagesCount: 12,
            hasEvidence: true,
            resolution: 'Remboursement acheteur',
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _FilterChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? OcalmColors.primary : OcalmColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? OcalmColors.primary : OcalmColors.divider),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isActive ? Colors.white : OcalmColors.textSecondary)),
    );
  }
}

class _LitigeCard extends StatelessWidget {
  final String reference;
  final String acheteur;
  final String vendeur;
  final int montant;
  final String raison;
  final String status;
  final String since;
  final int messagesCount;
  final bool hasEvidence;
  final String? resolution;

  const _LitigeCard({
    required this.reference,
    required this.acheteur,
    required this.vendeur,
    required this.montant,
    required this.raison,
    required this.status,
    required this.since,
    required this.messagesCount,
    required this.hasEvidence,
    this.resolution,
  });

  Color get _statusColor {
    switch (status) {
      case 'ouvert': return OcalmColors.statusDispute;
      case 'en_mediation': return OcalmColors.statusInDelivery;
      case 'resolu': return OcalmColors.success;
      default: return OcalmColors.textHint;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'ouvert': return 'Ouvert';
      case 'en_mediation': return 'En médiation';
      case 'resolu': return 'Résolu';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OcalmColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: status == 'ouvert' ? OcalmColors.statusDispute.withOpacity(0.3) : OcalmColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(reference, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary, fontFamily: 'monospace')),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(_statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor)),
                  ),
                ],
              ),
              Text('Depuis $since', style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
            ],
          ),
          const SizedBox(height: 12),

          // Raison
          Text(raison, style: const TextStyle(fontSize: 14, color: OcalmColors.textPrimary)),
          const SizedBox(height: 12),

          // Participants + montant
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: OcalmColors.textHint),
              const SizedBox(width: 4),
              Text('$acheteur vs $vendeur', style: const TextStyle(fontSize: 12, color: OcalmColors.textSecondary)),
              const Spacer(),
              Text('$montant FCFA', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: OcalmColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),

          // Meta info
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 13, color: OcalmColors.textHint),
              const SizedBox(width: 4),
              Text('$messagesCount messages', style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
              const SizedBox(width: 16),
              Icon(hasEvidence ? Icons.image : Icons.image_not_supported_outlined, size: 13, color: hasEvidence ? OcalmColors.success : OcalmColors.textHint),
              const SizedBox(width: 4),
              Text(hasEvidence ? 'Preuves jointes' : 'Pas de preuves', style: TextStyle(fontSize: 11, color: hasEvidence ? OcalmColors.success : OcalmColors.textHint)),
            ],
          ),

          // Resolution
          if (resolution != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: OcalmColors.success.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 14, color: OcalmColors.success),
                  const SizedBox(width: 8),
                  Text('Résolution: $resolution', style: const TextStyle(fontSize: 12, color: OcalmColors.success, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],

          // Actions (only for open disputes)
          if (status != 'resolu') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined, size: 16),
                    label: const Text('Médier'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.gavel, size: 16),
                    label: const Text('Résoudre'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
