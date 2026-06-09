import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/dashboard';

    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0066FF), Color(0xFF4D94FF)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OCALM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _MenuItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  route: '/dashboard',
                  isActive: currentRoute == '/dashboard',
                ),
                _MenuItem(
                  icon: Icons.people_outline,
                  label: 'Utilisateurs',
                  route: '/users',
                  isActive: currentRoute == '/users',
                ),
                _MenuItem(
                  icon: Icons.swap_horiz,
                  label: 'Transactions',
                  route: '/transactions',
                  isActive: currentRoute == '/transactions',
                ),
                _MenuItem(
                  icon: Icons.gavel_outlined,
                  label: 'Litiges',
                  route: '/litiges',
                  isActive: currentRoute == '/litiges',
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Paramètres',
                  route: '/settings',
                  isActive: currentRoute == '/settings',
                ),
              ],
            ),
          ),
          // User profile
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF0066FF),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        'sokaoptique@gmail.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xFF6B7280)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? const Color(0xFF0066FF) : const Color(0xFF6B7280),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? const Color(0xFF0066FF) : const Color(0xFF1A1A2E),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: const Color(0xFF0066FF).withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
