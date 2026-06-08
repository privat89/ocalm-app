import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.backgroundGrey,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            _AdminSidebar(),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard OCALM',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: OcalmColors.textPrimary),
                            ),
                            SizedBox(height: 4),
                            Text('Vue d\'ensemble en temps réel', style: TextStyle(fontSize: 13, color: OcalmColors.textHint)),
                          ],
                        ),
                        Row(
                          children: [
                            _PeriodChip(label: 'Aujourd\'hui', isActive: true),
                            const SizedBox(width: 8),
                            _PeriodChip(label: '7 jours', isActive: false),
                            const SizedBox(width: 8),
                            _PeriodChip(label: '30 jours', isActive: false),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // KPI Cards Row
                    Row(
                      children: [
                        Expanded(child: _KPICard(
                          title: 'Transactions actives',
                          value: '47',
                          trend: '+12%',
                          trendUp: true,
                          icon: Icons.swap_horiz,
                          color: OcalmColors.primary,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Volume sécurisé',
                          value: '2.4M FCFA',
                          trend: '+8%',
                          trendUp: true,
                          icon: Icons.shield_outlined,
                          color: OcalmColors.success,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Revenus OCALM',
                          value: '156 000 F',
                          trend: '+15%',
                          trendUp: true,
                          icon: Icons.account_balance_wallet,
                          color: const Color(0xFFFF9900),
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Litiges ouverts',
                          value: '3',
                          trend: '-2',
                          trendUp: false,
                          icon: Icons.warning_amber_outlined,
                          color: OcalmColors.statusDispute,
                        )),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Second row KPIs
                    Row(
                      children: [
                        Expanded(child: _KPICard(
                          title: 'Utilisateurs actifs',
                          value: '1 247',
                          trend: '+23%',
                          trendUp: true,
                          icon: Icons.people_outline,
                          color: OcalmColors.primary,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Livreurs disponibles',
                          value: '18',
                          trend: '',
                          trendUp: true,
                          icon: Icons.delivery_dining,
                          color: const Color(0xFFFF9900),
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Taux de succès',
                          value: '96.2%',
                          trend: '+1.4%',
                          trendUp: true,
                          icon: Icons.check_circle_outline,
                          color: OcalmColors.success,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _KPICard(
                          title: 'Temps moyen livraison',
                          value: '48 min',
                          trend: '-5 min',
                          trendUp: true,
                          icon: Icons.timer_outlined,
                          color: OcalmColors.primary,
                        )),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Transactions récentes + Litiges
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transactions récentes
                        Expanded(
                          flex: 3,
                          child: _DashboardCard(
                            title: 'Transactions récentes',
                            child: Column(
                              children: [
                                _TransactionRow(ref: 'OC-2025-00152', acheteur: 'Privat M.', vendeur: 'Moussa K.', montant: 35000, statut: 'fonds_bloques'),
                                _TransactionRow(ref: 'OC-2025-00151', acheteur: 'Fatou B.', vendeur: 'Ibrahim T.', montant: 18000, statut: 'en_livraison'),
                                _TransactionRow(ref: 'OC-2025-00150', acheteur: 'Kofi D.', vendeur: 'Aminata D.', montant: 65000, statut: 'livre_valide'),
                                _TransactionRow(ref: 'OC-2025-00149', acheteur: 'Awa S.', vendeur: 'Jean-Marc L.', montant: 120000, statut: 'livre_valide'),
                                _TransactionRow(ref: 'OC-2025-00148', acheteur: 'Mamadou C.', vendeur: 'Privat M.', montant: 8000, statut: 'litige'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Litiges actifs
                        Expanded(
                          flex: 2,
                          child: _DashboardCard(
                            title: 'Litiges actifs',
                            child: Column(
                              children: [
                                _DisputeRow(ref: 'OC-2025-00148', raison: 'Article non conforme', montant: 8000, since: '2h'),
                                _DisputeRow(ref: 'OC-2025-00139', raison: 'Non reçu', montant: 45000, since: '1j'),
                                _DisputeRow(ref: 'OC-2025-00131', raison: 'Colis endommagé', montant: 22000, since: '3j'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Revenus breakdown
                    _DashboardCard(
                      title: 'Répartition des revenus (30 derniers jours)',
                      child: Row(
                        children: [
                          Expanded(child: _RevenueBar(label: '0-10K', count: 145, amount: 14500, color: OcalmColors.primary.withOpacity(0.4))),
                          Expanded(child: _RevenueBar(label: '10-30K', count: 89, amount: 26700, color: OcalmColors.primary.withOpacity(0.6))),
                          Expanded(child: _RevenueBar(label: '30-100K', count: 52, amount: 26000, color: OcalmColors.primary.withOpacity(0.75))),
                          Expanded(child: _RevenueBar(label: '100-500K', count: 21, amount: 21000, color: OcalmColors.primary.withOpacity(0.9))),
                          Expanded(child: _RevenueBar(label: '500K+', count: 4, amount: 10000, color: OcalmColors.primary)),
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

// ===== SIDEBAR =====
class _AdminSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: OcalmColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // Logo
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              const Text('OCALM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Administration', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
          const SizedBox(height: 32),
          _SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', isActive: true),
          _SidebarItem(icon: Icons.swap_horiz, label: 'Transactions', isActive: false),
          _SidebarItem(icon: Icons.people_outline, label: 'Utilisateurs', isActive: false),
          _SidebarItem(icon: Icons.delivery_dining, label: 'Livreurs', isActive: false),
          _SidebarItem(icon: Icons.warning_amber_outlined, label: 'Litiges', isActive: false),
          _SidebarItem(icon: Icons.account_balance_wallet, label: 'Finances', isActive: false),
          _SidebarItem(icon: Icons.bar_chart, label: 'Statistiques', isActive: false),
          _SidebarItem(icon: Icons.notifications_outlined, label: 'Notifications', isActive: false),
          const Spacer(),
          _SidebarItem(icon: Icons.settings_outlined, label: 'Paramètres', isActive: false),
          _SidebarItem(icon: Icons.logout, label: 'Déconnexion', isActive: false),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _SidebarItem({required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white60, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white60, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}

// ===== KPI CARD =====
class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool trendUp;
  final IconData icon;
  final Color color;

  const _KPICard({required this.title, required this.value, required this.trend, required this.trendUp, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OcalmColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OcalmColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              if (trend.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (trendUp ? OcalmColors.success : OcalmColors.statusDispute).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(trend, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: trendUp ? OcalmColors.success : OcalmColors.statusDispute)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: OcalmColors.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: OcalmColors.textHint)),
        ],
      ),
    );
  }
}

// ===== PERIOD CHIP =====
class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _PeriodChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? OcalmColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? OcalmColors.primary : OcalmColors.divider),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isActive ? Colors.white : OcalmColors.textHint)),
    );
  }
}

// ===== DASHBOARD CARD =====
class _DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashboardCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OcalmColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OcalmColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ===== TRANSACTION ROW =====
class _TransactionRow extends StatelessWidget {
  final String ref;
  final String acheteur;
  final String vendeur;
  final int montant;
  final String statut;

  const _TransactionRow({required this.ref, required this.acheteur, required this.vendeur, required this.montant, required this.statut});

  Color get _statusColor {
    switch (statut) {
      case 'fonds_bloques': return OcalmColors.statusLocked;
      case 'en_livraison': return OcalmColors.statusInDelivery;
      case 'livre_valide': return OcalmColors.statusDelivered;
      case 'litige': return OcalmColors.statusDispute;
      default: return OcalmColors.statusPending;
    }
  }

  String get _statusLabel {
    switch (statut) {
      case 'fonds_bloques': return 'Verrouillé';
      case 'en_livraison': return 'En livraison';
      case 'livre_valide': return 'Validé';
      case 'litige': return 'Litige';
      default: return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(ref, style: const TextStyle(fontSize: 12, color: OcalmColors.textHint, fontFamily: 'monospace'))),
          Expanded(child: Text('$acheteur → $vendeur', style: const TextStyle(fontSize: 13, color: OcalmColors.textPrimary))),
          SizedBox(width: 90, child: Text('$montant F', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary))),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(_statusLabel, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor)),
          ),
        ],
      ),
    );
  }
}

// ===== DISPUTE ROW =====
class _DisputeRow extends StatelessWidget {
  final String ref;
  final String raison;
  final int montant;
  final String since;

  const _DisputeRow({required this.ref, required this.raison, required this.montant, required this.since});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OcalmColors.statusDispute.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OcalmColors.statusDispute.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ref, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary)),
              Text('Depuis $since', style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
            ],
          ),
          const SizedBox(height: 4),
          Text(raison, style: const TextStyle(fontSize: 12, color: OcalmColors.statusDispute)),
          const SizedBox(height: 4),
          Text('$montant FCFA gelés', style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
        ],
      ),
    );
  }
}

// ===== REVENUE BAR =====
class _RevenueBar extends StatelessWidget {
  final String label;
  final int count;
  final int amount;
  final Color color;

  const _RevenueBar({required this.label, required this.count, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count tx', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: OcalmColors.textPrimary)),
        const SizedBox(height: 6),
        Container(
          height: (count / 145 * 80).clamp(10, 80),
          width: 40,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: OcalmColors.textHint)),
        Text('${amount}F', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: OcalmColors.textSecondary)),
      ],
    );
  }
}
