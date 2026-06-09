import 'package:flutter/material.dart';

/// Couleurs officielles OCALM — Direction Bleu & Blanc
/// "Fais tes affaires... Au Calme."
class OcalmColors {
  OcalmColors._();

  // ─── Couleurs primaires ──────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);       // Blanc pur - fond principal
  static const Color primary = Color(0xFF0066FF);          // Bleu électrique - CTAs, accents
  static const Color textPrimary = Color(0xFF1A1A2E);      // Bleu nuit - texte principal
  static const Color surface = Color(0xFFF0F4F8);          // Gris bleu très clair - cartes

  // ─── Couleurs secondaires ────────────────────────────────────────
  static const Color primaryLight = Color(0xFF4D94FF);     // Bleu clair (hover)
  static const Color primaryDark = Color(0xFF0047CC);      // Bleu foncé (pressed)
  static const Color surfaceLight = Color(0xFFE8EEF4);     // Surface élevée niveau 2
  static const Color surfaceBorder = Color(0xFFD0D8E0);    // Bordure subtile des cartes

  // ─── Glass-morphism ──────────────────────────────────────────────
  static const Color glassBackground = Color(0x0F000000);  // 6% noir
  static const Color glassBorder = Color(0x33000000);      // 20% noir
  static const Color glassHighlight = Color(0x1A0066FF);   // 10% bleu glow

  // ─── Couleurs de statut ──────────────────────────────────────────
  static const Color statusPending = Color(0xFFFFB800);    // En attente - Ambre
  static const Color statusLocked = Color(0xFF9B59FF);     // Fonds bloqués - Violet
  static const Color statusInDelivery = Color(0xFF00B4D8); // En livraison - Cyan
  static const Color statusDelivered = Color(0xFF00D68F);  // Livré/validé - Vert menthe
  static const Color statusDispute = Color(0xFFFF3D71);    // Litige - Rose-rouge
  static const Color success = Color(0xFF00D68F);          // Succès global

  // ─── Couleurs de fond ────────────────────────────────────────────
  static const Color backgroundDarker = Color(0xFFF5F7FA); // Fond plus profond (modales)
  static const Color backgroundGradientEnd = Color(0xFFE8EEF4); // Fin de gradient
  static const Color divider = Color(0xFFD0D8E0);          // Séparateurs subtils

  // ─── Couleurs texte ──────────────────────────────────────────────
  static const Color textSecondary = Color(0xB31A1A2E);    // 70% bleu nuit
  static const Color textHint = Color(0x661A1A2E);         // 40% bleu nuit
  static const Color textOnPrimary = Color(0xFFFFFFFF);    // Texte sur bouton bleu
  static const Color textOnSuccess = Color(0xFFFFFFFF);    // Texte sur vert

  // ─── Motifs & Déco ──────────────────────────────────────────────
  static const Color patternOverlay = Color(0x1A0066FF);   // 10% bleu pour motifs
  static const Color glowOrange = Color(0x400066FF);       // Glow effect boutons bleu
}
