import 'package:flutter/material.dart';

/// Couleurs officielles OCALM — Direction Afro-Futuriste
/// "Fais tes affaires... Au Calme."
class OcalmColors {
  OcalmColors._();

  // ─── Couleurs primaires ──────────────────────────────────────────
  static const Color background = Color(0xFF1A0F2E);       // Deep space indigo-purple
  static const Color primary = Color(0xFFFF6B35);          // Vibrant orange - CTAs, accents
  static const Color textPrimary = Color(0xFFF5E6D3);      // Warm cream - texte principal
  static const Color surface = Color(0xFF241845);          // Carte/surface élevée

  // ─── Couleurs secondaires ────────────────────────────────────────
  static const Color primaryLight = Color(0xFFFF8F5E);     // Orange clair (hover)
  static const Color primaryDark = Color(0xFFE55A2B);      // Orange foncé (pressed)
  static const Color surfaceLight = Color(0xFF2E2055);     // Surface élevée niveau 2
  static const Color surfaceBorder = Color(0xFF3D2A6E);    // Bordure lumineuse des cartes

  // ─── Glass-morphism ──────────────────────────────────────────────
  static const Color glassBackground = Color(0x0FFFFFFF);  // 6% blanc
  static const Color glassBorder = Color(0x33FFFFFF);      // 20% blanc
  static const Color glassHighlight = Color(0x1AFF6B35);   // 10% orange glow

  // ─── Couleurs de statut ──────────────────────────────────────────
  static const Color statusPending = Color(0xFFFFB800);    // En attente - Ambre
  static const Color statusLocked = Color(0xFF9B59FF);     // Fonds bloqués - Violet
  static const Color statusInDelivery = Color(0xFF00B4D8); // En livraison - Cyan
  static const Color statusDelivered = Color(0xFF00D68F);  // Livré/validé - Vert menthe
  static const Color statusDispute = Color(0xFFFF3D71);    // Litige - Rose-rouge
  static const Color success = Color(0xFF00D68F);          // Succès global

  // ─── Couleurs de fond ────────────────────────────────────────────
  static const Color backgroundDarker = Color(0xFF120A22); // Fond plus profond (modales)
  static const Color backgroundGradientEnd = Color(0xFF0D0719); // Fin de gradient
  static const Color divider = Color(0xFF3D2A6E);          // Séparateurs subtils

  // ─── Couleurs texte ──────────────────────────────────────────────
  static const Color textSecondary = Color(0xB3F5E6D3);    // 70% cream
  static const Color textHint = Color(0x66F5E6D3);         // 40% cream
  static const Color textOnPrimary = Color(0xFFFFFFFF);    // Texte sur bouton orange
  static const Color textOnSuccess = Color(0xFF1A0F2E);    // Texte sur vert

  // ─── Motifs & Déco ──────────────────────────────────────────────
  static const Color patternOverlay = Color(0x1AF5E6D3);   // 10% cream pour motifs adinkra
  static const Color glowOrange = Color(0x40FF6B35);       // Glow effect boutons
}
