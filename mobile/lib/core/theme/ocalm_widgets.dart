import 'package:flutter/material.dart';
import 'ocalm_colors.dart';

/// Composants réutilisables OCALM — Style Afro-Futuriste
class OcalmWidgets {
  OcalmWidgets._();

  // ─── Glass Card ───────────────────────────────────────────────────
  /// Carte avec effet glass-morphism et bordure lumineuse
  static Widget glassCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double borderRadius = 20,
    bool hasGlow = false,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: OcalmColors.glassBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: hasGlow ? OcalmColors.primary.withOpacity(0.3) : OcalmColors.glassBorder,
          width: 0.5,
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: OcalmColors.glowOrange,
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  // ─── Wallet Balance Card ──────────────────────────────────────────
  /// Grande carte solde avec glow orange
  static Widget walletCard({
    required String balance,
    String label = 'Solde disponible',
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OcalmColors.surface,
            OcalmColors.surfaceLight,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: OcalmColors.glassBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: OcalmColors.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: OcalmColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$balance FCFA',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SpaceGrotesk',
                    color: OcalmColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Transaction Card ─────────────────────────────────────────────
  static Widget transactionCard({
    required String title,
    required String amount,
    required TransactionStatus status,
    String? sellerName,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: OcalmColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OcalmColors.surfaceBorder, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: status.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(status.icon, color: status.color, size: 22),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: OcalmColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (sellerName != null)
                        Text(
                          sellerName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: OcalmColors.textHint,
                          ),
                        ),
                    ],
                  ),
                ),
                // Montant + badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$amount F',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SpaceGrotesk',
                        color: OcalmColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    statusBadge(status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Status Badge ─────────────────────────────────────────────────
  static Widget statusBadge(TransactionStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: status.color,
        ),
      ),
    );
  }

  // ─── Primary CTA Button (with glow) ──────────────────────────────
  static Widget primaryButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OcalmColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: OcalmColors.primary,
          foregroundColor: OcalmColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: OcalmColors.textOnPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────────────────
  static Widget sectionHeader({
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'SpaceGrotesk',
              color: OcalmColors.textPrimary,
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OcalmColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Transaction Status Enum ──────────────────────────────────────────
enum TransactionStatus {
  pending(
    label: 'En attente',
    color: OcalmColors.statusPending,
    icon: Icons.schedule_rounded,
  ),
  locked(
    label: 'Bloqué 🔒',
    color: OcalmColors.statusLocked,
    icon: Icons.lock_rounded,
  ),
  inDelivery(
    label: 'En livraison',
    color: OcalmColors.statusInDelivery,
    icon: Icons.local_shipping_rounded,
  ),
  delivered(
    label: 'Livré ✓',
    color: OcalmColors.statusDelivered,
    icon: Icons.check_circle_rounded,
  ),
  dispute(
    label: 'Litige',
    color: OcalmColors.statusDispute,
    icon: Icons.warning_rounded,
  );

  const TransactionStatus({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}
