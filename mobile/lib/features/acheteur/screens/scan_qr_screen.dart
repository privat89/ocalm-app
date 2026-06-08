import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';

class ScanQRScreen extends StatefulWidget {
  final String transactionRef;

  const ScanQRScreen({super.key, this.transactionRef = 'OC-2025-00147'});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool _isScanning = true;
  bool _isValidated = false;

  void _onQRScanned(String code) {
    setState(() {
      _isScanning = false;
      _isValidated = true;
    });

    // Show success
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: OcalmColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: OcalmColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction validée !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: OcalmColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Le vendeur et le livreur seront payés automatiquement.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: OcalmColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera placeholder
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // QR frame
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isValidated ? OcalmColors.success : Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isValidated
                        ? const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: OcalmColors.success,
                              size: 80,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.qr_code_2,
                              color: Colors.white30,
                              size: 100,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isValidated
                        ? 'QR code validé !'
                        : 'Scanne le QR code du livreur',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!_isValidated)
                    Text(
                      'Réf: ${widget.transactionRef}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flash_on, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          'Flash',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom: OTP alternative
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Simulate scan for demo
                if (!_isValidated)
                  OutlinedButton(
                    onPressed: () => _onQRScanned('mock-qr-code'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Simuler un scan (démo)'),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // TODO: Show OTP input screen
                  },
                  child: Text(
                    'Pas de QR ? Utiliser le code OTP',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
