import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_widgets.dart';

class LivreurHomeScreen extends StatefulWidget {
  const LivreurHomeScreen({super.key});

  @override
  State<LivreurHomeScreen> createState() => _LivreurHomeScreenState();
}

class _LivreurHomeScreenState extends State<LivreurHomeScreen> {
  bool _isDisponible = true;

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

              // Header + toggle disponibilité
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes courses',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SpaceGrotesk',
                            color: OcalmColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Livrez, scannez, soyez payés.', style: TextStyle(fontSize: 13, color: OcalmColors.textHint)),
                      ],
                    ),
                    // Disponibilité toggle
                    GestureDetector(
                      onTap: () => setState(() => _isDisponible = !_isDisponible),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: (_isDisponible ? OcalmColors.statusDelivered : OcalmColors.statusDispute).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isDisponible ? OcalmColors.statusDelivered : OcalmColors.statusDispute,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isDisponible ? OcalmColors.statusDelivered : OcalmColors.statusDispute,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isDisponible ? 'Dispo' : 'Pause',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _isDisponible ? OcalmColors.statusDelivered : OcalmColors.statusDispute,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Gains card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D1E00), Color(0xFF7A3D00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: OcalmColors.primary.withOpacity(0.3), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: OcalmColors.primary.withOpacity(0.15),
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
                        Icon(Icons.account_balance_wallet_rounded, color: OcalmColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text("Gains aujourd'hui", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '7 500 FCFA',
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
                        _GainChip(label: '5 courses', icon: Icons.delivery_dining_rounded),
                        const SizedBox(width: 12),
                        _GainChip(label: '23 km', icon: Icons.route_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Course active
              if (_isDisponible) ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: OcalmColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: OcalmColors.primary.withOpacity(0.3), width: 0.5),
                    boxShadow: [
                      BoxShadow(color: OcalmColors.primary.withOpacity(0.08), blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: OcalmColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('EN COURS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                          const Spacer(),
                          const Text('1 500 F', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'SpaceGrotesk', color: OcalmColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _CoursePoint(icon: Icons.circle, color: OcalmColors.statusDelivered, label: 'Pickup: Marcory, Rue 12'),
                      Container(
                        margin: const EdgeInsets.only(left: 9),
                        height: 22,
                        child: VerticalDivider(width: 2, color: OcalmColors.divider),
                      ),
                      _CoursePoint(icon: Icons.location_on_rounded, color: OcalmColors.primary, label: 'Drop: Plateau, Av. Botreau'),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(Icons.straighten_rounded, size: 14, color: OcalmColors.textHint),
                          const SizedBox(width: 6),
                          const Text('4.5 km', style: TextStyle(fontSize: 12, color: OcalmColors.textHint)),
                          const SizedBox(width: 16),
                          Icon(Icons.timer_rounded, size: 14, color: OcalmColors.textHint),
                          const SizedBox(width: 6),
                          const Text('~15 min', style: TextStyle(fontSize: 12, color: OcalmColors.textHint)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                              label: const Text('Scanner départ'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone_rounded, size: 18),
                              label: const Text('Appeler'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Courses disponibles
              OcalmWidgets.sectionHeader(title: 'Courses disponibles'),
              const SizedBox(height: 8),

              _CourseDispoCard(pickup: 'Cocody Angré', drop: 'Yopougon Maroc', distance: '8.2 km', gain: 2000),
              const SizedBox(height: 8),
              _CourseDispoCard(pickup: 'Treichville Gare', drop: 'Marcory Zone 4', distance: '3.1 km', gain: 1200),
              const SizedBox(height: 8),
              _CourseDispoCard(pickup: 'Adjamé Forum', drop: 'Plateau Cathédrale', distance: '5.7 km', gain: 1500),
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
            BottomNavigationBarItem(icon: Icon(Icons.delivery_dining_rounded), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Historique'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_rounded), label: 'Scanner'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class _GainChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _GainChip({required this.label, required this.icon});

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

class _CoursePoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _CoursePoint({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: OcalmColors.textPrimary)),
      ],
    );
  }
}

class _CourseDispoCard extends StatelessWidget {
  final String pickup;
  final String drop;
  final String distance;
  final int gain;

  const _CourseDispoCard({
    required this.pickup,
    required this.drop,
    required this.distance,
    required this.gain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OcalmColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OcalmColors.surfaceBorder, width: 0.5),
      ),
      child: Row(
        children: [
          // Route icon
          Column(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: OcalmColors.statusDelivered)),
              Container(width: 1.5, height: 22, color: OcalmColors.divider),
              Icon(Icons.location_on_rounded, size: 14, color: OcalmColors.primary),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pickup, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: OcalmColors.textPrimary)),
                const SizedBox(height: 6),
                Text(drop, style: const TextStyle(fontSize: 13, color: OcalmColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$gain F', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'SpaceGrotesk', color: OcalmColors.textPrimary)),
              const SizedBox(height: 4),
              Text(distance, style: const TextStyle(fontSize: 11, color: OcalmColors.textHint)),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: OcalmColors.statusDelivered.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_rounded, color: OcalmColors.statusDelivered, size: 20),
          ),
        ],
      ),
    );
  }
}
