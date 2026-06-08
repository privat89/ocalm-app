import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_widgets.dart';
import '../../../core/theme/ocalm_animations.dart';

class AcheteurHomeScreen extends StatefulWidget {
  const AcheteurHomeScreen({super.key});

  @override
  State<AcheteurHomeScreen> createState() => _AcheteurHomeScreenState();
}

class _AcheteurHomeScreenState extends State<AcheteurHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _walletController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _walletScale;
  late Animation<double> _walletFade;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: OcalmAnimations.defaultCurve),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -15), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerController, curve: OcalmAnimations.defaultCurve),
    );

    // Wallet card animation
    _walletController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _walletScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _walletController, curve: OcalmAnimations.entryCurve),
    );
    _walletFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _walletController, curve: const Interval(0, 0.7)),
    );

    // List animation
    _listController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _walletController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _listController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _walletController.dispose();
    _listController.dispose();
    super.dispose();
  }

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

              // ─── Header (animated) ────────────────────────────────
              AnimatedBuilder2(
                listenable: _headerController,
                builder: (context, _) => Opacity(
                  opacity: _headerFade.value,
                  child: Transform.translate(
                    offset: _headerSlide.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Salut, Privat 👋',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SpaceGrotesk',
                                  color: OcalmColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fais tes affaires... Au Calme.',
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
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(Icons.notifications_outlined, color: OcalmColors.textPrimary, size: 22),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 12,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: OcalmColors.primary, shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Wallet Card (animated scale + fade) ──────────────
              AnimatedBuilder2(
                listenable: _walletController,
                builder: (context, _) => Opacity(
                  opacity: _walletFade.value,
                  child: Transform.scale(
                    scale: _walletScale.value,
                    child: _buildWalletCard(),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ─── Summary chips (animated) ─────────────────────────
              FadeInWidget(
                delay: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _SummaryChip(label: '3 en cours', icon: Icons.pending_outlined, color: OcalmColors.statusPending),
                      const SizedBox(width: 12),
                      _SummaryChip(label: '12 terminées', icon: Icons.check_circle_outline, color: OcalmColors.statusDelivered),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ─── CTA Button (animated) ────────────────────────────
              FadeInWidget(
                delay: const Duration(milliseconds: 600),
                slideOffset: const Offset(0, 20),
                child: OcalmWidgets.primaryButton(
                  label: 'Nouvelle transaction',
                  icon: Icons.add_circle_outline,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 32),

              // ─── Section header ───────────────────────────────────
              FadeInWidget(
                delay: const Duration(milliseconds: 700),
                child: OcalmWidgets.sectionHeader(
                  title: 'Transactions en cours',
                  actionLabel: 'Voir tout',
                  onAction: () {},
                ),
              ),
              const SizedBox(height: 8),

              // ─── Transaction list (staggered) ─────────────────────
              StaggeredList(
                delay: const Duration(milliseconds: 800),
                children: [
                  OcalmWidgets.transactionCard(
                    title: 'Samsung Galaxy A14',
                    amount: '35 000',
                    status: TransactionStatus.locked,
                    sellerName: 'Vendeur: Moussa K.',
                    onTap: () {},
                  ),
                  OcalmWidgets.transactionCard(
                    title: 'Air Jordan 4 Retro',
                    amount: '85 000',
                    status: TransactionStatus.inDelivery,
                    sellerName: 'Vendeur: Aminata D.',
                    onTap: () {},
                  ),
                  OcalmWidgets.transactionCard(
                    title: 'MacBook Pro 2022',
                    amount: '450 000',
                    status: TransactionStatus.delivered,
                    sellerName: 'Vendeur: Ibrahim T.',
                    onTap: () {},
                  ),
                  OcalmWidgets.transactionCard(
                    title: 'Écouteurs Bluetooth',
                    amount: '15 000',
                    status: TransactionStatus.pending,
                    sellerName: 'Vendeur: Koffi B.',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // ─── Bottom Navigation ──────────────────────────────────────────
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
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_rounded), label: 'Scanner'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [OcalmColors.surface, OcalmColors.surfaceLight],
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Montant sécurisé', style: TextStyle(fontSize: 14, color: OcalmColors.textSecondary)),
            const SizedBox(height: 8),
            AnimatedCounter(
              value: 125000,
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
    );
  }
}

// ─── Summary Chip ───────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SummaryChip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
