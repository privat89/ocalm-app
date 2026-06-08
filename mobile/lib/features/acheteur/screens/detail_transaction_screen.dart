import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/constants/ocalm_constants.dart';

class DetailTransactionScreen extends StatelessWidget {
  final String reference;
  final String article;
  final String vendeur;
  final int montant;
  final TransactionStatus status;

  const DetailTransactionScreen({
    super.key,
    this.reference = 'OC-2025-00147',
    this.article = 'Samsung Galaxy A14',
    this.vendeur = 'Moussa K.',
    this.montant = 35000,
    this.status = TransactionStatus.enLivraison,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Détail transaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reference + status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: OcalmColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: OcalmColors.divider),
              ),
              child: Column(
                children: [
                  Text(
                    reference,
                    style: const TextStyle(
                      fontSize: 12,
                      color: OcalmColors.textHint,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: OcalmColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$montant FCFA',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: OcalmColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StatusBadge(status: status),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            const Text(
              'Suivi de la transaction',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: OcalmColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _TimelineStep(
              title: 'Paiement reçu',
              subtitle: 'Fonds bloqués en séquestre',
              time: '14:30',
              isCompleted: true,
              isFirst: true,
            ),
            _TimelineStep(
              title: 'Vendeur notifié',
              subtitle: 'Moussa prépare le colis',
              time: '14:31',
              isCompleted: true,
            ),
            _TimelineStep(
              title: 'Colis pris en charge',
              subtitle: 'Livreur: Koné A. — En route',
              time: '15:45',
              isCompleted: status == TransactionStatus.enLivraison ||
                  status == TransactionStatus.livreValide,
            ),
            _TimelineStep(
              title: 'Livré et validé',
              subtitle: 'Scanne le QR du livreur pour confirmer',
              time: '',
              isCompleted: status == TransactionStatus.livreValide,
              isLast: true,
            ),
            const SizedBox(height: 28),

            // Infos vendeur/livreur
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: OcalmColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _ParticipantCard(
              icon: Icons.storefront_outlined,
              label: 'Vendeur',
              name: vendeur,
              phone: '+225 07 XX XX XX',
              color: OcalmColors.success,
            ),
            const SizedBox(height: 10),
            _ParticipantCard(
              icon: Icons.delivery_dining,
              label: 'Livreur',
              name: 'Koné A.',
              phone: '+225 05 XX XX XX',
              color: const Color(0xFFFF9900),
            ),
            const SizedBox(height: 28),

            // Action buttons
            if (status == TransactionStatus.enLivraison) ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open QR scanner
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 22),
                  label: const Text('Scanner QR pour valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OcalmColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Enter OTP manually
                  },
                  icon: const Icon(Icons.pin_outlined, size: 20),
                  label: const Text('Entrer le code OTP'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Open dispute
                  },
                  icon: const Icon(Icons.flag_outlined,
                      size: 18, color: OcalmColors.statusDispute),
                  label: const Text(
                    'Signaler un problème',
                    style: TextStyle(color: OcalmColors.statusDispute),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case TransactionStatus.fondsBloques:
        return OcalmColors.statusLocked;
      case TransactionStatus.enLivraison:
        return OcalmColors.statusInDelivery;
      case TransactionStatus.livreValide:
        return OcalmColors.statusDelivered;
      case TransactionStatus.litige:
        return OcalmColors.statusDispute;
      default:
        return OcalmColors.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isCompleted,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + dot
        SizedBox(
          width: 24,
          child: Column(
            children: [
              if (!isFirst)
                Container(width: 2, height: 8, color: isCompleted ? OcalmColors.success : OcalmColors.divider),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? OcalmColors.success : OcalmColors.divider,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 8, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(width: 2, height: 36, color: isCompleted ? OcalmColors.success : OcalmColors.divider),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? OcalmColors.textPrimary : OcalmColors.textHint,
                      ),
                    ),
                    if (time.isNotEmpty)
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12, color: OcalmColors.textHint),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: OcalmColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String name;
  final String phone;
  final Color color;

  const _ParticipantCard({
    required this.icon,
    required this.label,
    required this.name,
    required this.phone,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OcalmColors.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.phone_outlined, color: color, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
