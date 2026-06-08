import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedCountryCode = '+225';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+225', 'country': '🇨🇮 Côte d\'Ivoire'},
    {'code': '+221', 'country': '🇸🇳 Sénégal'},
    {'code': '+226', 'country': '🇧🇫 Burkina Faso'},
    {'code': '+228', 'country': '🇹🇬 Togo'},
    {'code': '+229', 'country': '🇧🇯 Bénin'},
    {'code': '+223', 'country': '🇲🇱 Mali'},
  ];

  void _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            phoneNumber: '$_selectedCountryCode ${_phoneController.text}',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Shield icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: OcalmColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: OcalmColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),

                // Header
                const Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SpaceGrotesk',
                    color: OcalmColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre ton numéro de téléphone pour recevoir un code de vérification.',
                  style: TextStyle(
                    fontSize: 15,
                    color: OcalmColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Country code + phone number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country code dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: OcalmColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: OcalmColors.surfaceBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          dropdownColor: OcalmColors.surface,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: OcalmColors.textPrimary,
                          ),
                          items: _countryCodes.map((item) {
                            return DropdownMenuItem(
                              value: item['code'],
                              child: Text(item['code']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCountryCode = value!);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Phone input
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: OcalmColors.textPrimary,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          hintText: '07 XX XX XX XX',
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Numéro invalide';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Info text
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: OcalmColors.textHint),
                    const SizedBox(width: 6),
                    const Text(
                      'Tu recevras un SMS avec un code à 6 chiffres',
                      style: TextStyle(fontSize: 12, color: OcalmColors.textHint),
                    ),
                  ],
                ),

                const Spacer(),

                // CTA Button
                OcalmWidgets.primaryButton(
                  label: 'Recevoir le code',
                  onPressed: _sendOTP,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                // Terms
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'En continuant, tu acceptes nos ',
                      style: const TextStyle(fontSize: 12, color: OcalmColors.textHint),
                      children: [
                        TextSpan(
                          text: 'conditions d\'utilisation',
                          style: const TextStyle(
                            color: OcalmColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Écran de vérification OTP — Afro-Futuriste
class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) _canResend = true;
      });
      return _resendCountdown > 0;
    });
  }

  void _onOTPChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) _verifyOTP(otp);
  }

  void _verifyOTP(String otp) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      // TODO: Navigate to role selection or home
    }
  }

  void _resendOTP() {
    if (!_canResend) return;
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });
    _startCountdown();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: OcalmColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Vérifie ton numéro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SpaceGrotesk',
                  color: OcalmColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Code envoyé au ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 15, color: OcalmColors.textSecondary),
              ),
              const SizedBox(height: 48),

              // OTP Input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 58,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: _controllers[index].text.isNotEmpty
                            ? OcalmColors.primary.withOpacity(0.08)
                            : OcalmColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _controllers[index].text.isNotEmpty
                                ? OcalmColors.primary
                                : OcalmColors.surfaceBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _controllers[index].text.isNotEmpty
                                ? OcalmColors.primary
                                : OcalmColors.surfaceBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: OcalmColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SpaceGrotesk',
                        color: OcalmColors.textPrimary,
                      ),
                      onChanged: (value) => _onOTPChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Resend
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _resendOTP,
                        child: const Text(
                          'Renvoyer le code',
                          style: TextStyle(
                            color: OcalmColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Renvoyer dans ${_resendCountdown}s',
                        style: const TextStyle(
                          color: OcalmColors.textHint,
                          fontSize: 14,
                        ),
                      ),
              ),

              const Spacer(),

              if (_isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: OcalmColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const CircularProgressIndicator(
                      color: OcalmColors.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
