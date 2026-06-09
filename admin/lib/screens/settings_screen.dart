import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView(
                        children: [
                          _buildSection('Configuration générale', [
                            _buildTile('Frais OCALM', '1%', Icons.percent),
                            _buildTile('Devise', 'FCFA', Icons.attach_money),
                            _buildTile('Timeout OTP', '5 minutes', Icons.timer),
                          ]),
                          const SizedBox(height: 24),
                          _buildSection('Notifications', [
                            _buildSwitchTile('Email admins', true),
                            _buildSwitchTile('Alertes litiges', true),
                            _buildSwitchTile('Rapports quotidiens', false),
                          ]),
                          const SizedBox(height: 24),
                          _buildSection('Sécurité', [
                            _buildTile('2FA obligatoire', 'Activé', Icons.security),
                            _buildTile('Session timeout', '30 min', Icons.lock_clock),
                            _buildTile('Logs de connexion', 'Voir', Icons.history),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0066FF)),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SwitchListTile(
          title: Text(title),
          value: value,
          activeColor: const Color(0xFF0066FF),
          onChanged: (v) {},
        );
      },
    );
  }
}
