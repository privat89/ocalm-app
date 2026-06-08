import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/constants/ocalm_constants.dart';

class NouvelleTransactionScreen extends StatefulWidget {
  const NouvelleTransactionScreen({super.key});

  @override
  State<NouvelleTransactionScreen> createState() =>
      _NouvelleTransactionScreenState();
}

class _NouvelleTransactionScreenState extends State<NouvelleTransactionScreen> {
  final _montantController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _vendeurController = TextEditingController();
  bool _avecLivraison = true;
  int _montant = 0;
  int _step = 0; // 0: form, 1: résumé

  int get _frais => OcalmFees.calculateFees(_montant);
  int get _fraisLivraison => _avecLivraison ? 1500 : 0;
  int get _total => _montant + _frais + _fraisLivraison;

  void _onMontantChanged(String value) {
    setState(() {
      _montant = int.tryParse(value.replaceAll(' ', '')) ?? 0;
    });
  }

  @override
  void dispose() {
    _montantController.dispose();
    _descriptionController.dispose();
    _vendeurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(_step == 0 ? 'Nouvelle transaction' : 'Confirmation'),
      ),
      body: _step == 0 ? _buildForm() : _buildResume(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: OcalmColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OcalmColors.primary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: OcalmColors.primary, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'L\'argent sera bloqué en séquestre jusqu\'à la confirmation de réception.',
                    style: TextStyle(fontSize: 12, color: OcalmColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Montant
          const Text(
            'Montant de l\'article',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OcalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _montantController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _onMontantChanged,
            decoration: const InputDecoration(
              hintText: '25 000',
              suffixText: 'FCFA',
              suffixStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: OcalmColors.textPrimary,
              ),
            ),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: OcalmColors.textPrimary,
            ),
          ),

          // Frais calculation
          if (_montant > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: OcalmColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: OcalmColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'Frais OCALM : $_frais FCFA (protection garantie)',
                    style: TextStyle(
                      fontSize: 12,
                      color: OcalmColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Description
          const Text(
            'Description de l\'article',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OcalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Ex: Samsung Galaxy A14, noir, neuf',
            ),
          ),
          const SizedBox(height: 24),

          // Vendeur
          const Text(
            'Numéro du vendeur',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OcalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _vendeurController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(
              hintText: '07 XX XX XX XX',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),

          // Livraison toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OcalmColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Livraison par coursier',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: OcalmColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _avecLivraison ? '~1 500 FCFA' : 'Je récupère moi-même',
                      style: const TextStyle(
                        fontSize: 12,
                        color: OcalmColors.textHint,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _avecLivraison,
                  onChanged: (v) => setState(() => _avecLivraison = v),
                  activeColor: OcalmColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _montant > 0 &&
                      _descriptionController.text.isNotEmpty &&
                      _vendeurController.text.length >= 8
                  ? () => setState(() => _step = 1)
                  : null,
              child: const Text('Continuer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResume() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Resume card
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
                const Icon(
                  Icons.shield_outlined,
                  color: OcalmColors.primary,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Résumé de la transaction',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: OcalmColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _ResumeRow(label: 'Article', value: _descriptionController.text),
                _ResumeRow(label: 'Vendeur', value: '+225 ${_vendeurController.text}'),
                _ResumeRow(label: 'Livraison', value: _avecLivraison ? 'Oui (coursier)' : 'Non'),
                const Divider(height: 24),
                _ResumeRow(label: 'Montant article', value: '$_montant FCFA'),
                _ResumeRow(label: 'Frais OCALM', value: '$_frais FCFA'),
                if (_avecLivraison)
                  _ResumeRow(label: 'Frais livraison', value: '$_fraisLivraison FCFA'),
                const Divider(height: 24),
                _ResumeRow(
                  label: 'TOTAL À PAYER',
                  value: '$_total FCFA',
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Payment method
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                    color: const Color(0xFF1DC3C3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'W',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payer avec Wave',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: OcalmColors.textPrimary,
                      ),
                    ),
                    Text(
                      '07 XX XX XX XX',
                      style: TextStyle(fontSize: 12, color: OcalmColors.textHint),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.check_circle, color: OcalmColors.success),
              ],
            ),
          ),

          const Spacer(),

          // Pay button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Initier le paiement Wave
                _showPaymentConfirmation(context);
              },
              icon: const Icon(Icons.lock_outline, size: 20),
              label: Text('Payer $_total FCFA et sécuriser'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'L\'argent sera bloqué jusqu\'à ta confirmation',
            style: TextStyle(fontSize: 12, color: OcalmColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: OcalmColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: OcalmColors.success,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Paiement en cours...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: OcalmColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu vas recevoir une demande de paiement Wave.\nConfirme sur ton téléphone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: OcalmColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: OcalmColors.primary),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ResumeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ResumeRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold ? OcalmColors.textPrimary : OcalmColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: OcalmColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
