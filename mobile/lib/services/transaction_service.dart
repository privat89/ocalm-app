import 'api_service.dart';
import '../core/constants/ocalm_constants.dart';

/// Service de gestion des transactions (séquestre)
class TransactionService {
  final ApiService _api;

  TransactionService(this._api);

  /// Crée une nouvelle transaction sécurisée
  Future<Map<String, dynamic>> createTransaction({
    required int montant,
    required String description,
    required String vendeurPhone,
    required bool avecLivraison,
  }) async {
    final frais = OcalmFees.calculateFees(montant);
    final fraisLivraison = avecLivraison ? 1500 : 0;
    final total = montant + frais + fraisLivraison;

    // MOCK
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'transaction': {
        'id': 'tx-${DateTime.now().millisecondsSinceEpoch}',
        'reference': 'OC-2025-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
        'montant_article': montant,
        'frais_ocalm': frais,
        'frais_livraison': fraisLivraison,
        'total': total,
        'description': description,
        'vendeur_phone': vendeurPhone,
        'avec_livraison': avecLivraison,
        'statut': 'en_attente_paiement',
        'created_at': DateTime.now().toIso8601String(),
      },
      'payment_url': 'https://pay.wave.com/mock-session-id', // URL Wave
    };

    // REAL:
    // final response = await _api.post('/transactions', data: { ... });
    // return response.data;
  }

  /// Récupère les transactions de l'acheteur
  Future<List<Map<String, dynamic>>> getAcheteurTransactions() async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {
        'id': 'tx-001',
        'reference': 'OC-2025-00147',
        'article': 'Samsung Galaxy A14',
        'vendeur': 'Moussa K.',
        'montant': 35000,
        'statut': 'fonds_bloques',
        'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'tx-002',
        'reference': 'OC-2025-00145',
        'article': 'Box Internet 4G',
        'vendeur': 'Aminata D.',
        'montant': 25000,
        'statut': 'en_livraison',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'tx-003',
        'reference': 'OC-2025-00140',
        'article': 'Écouteurs Bluetooth',
        'vendeur': 'Ibrahim T.',
        'montant': 15000,
        'statut': 'livre_valide',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
    ];

    // REAL:
    // final response = await _api.get('/transactions/acheteur');
    // return List<Map<String, dynamic>>.from(response.data['transactions']);
  }

  /// Récupère les ventes du vendeur
  Future<List<Map<String, dynamic>>> getVendeurVentes() async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {
        'id': 'tx-001',
        'reference': 'OC-2025-00147',
        'article': 'Samsung Galaxy A14',
        'acheteur': 'Privat M.',
        'montant': 35000,
        'statut': 'fonds_bloques',
        'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      },
      {
        'id': 'tx-004',
        'reference': 'OC-2025-00148',
        'article': 'Écouteurs JBL',
        'acheteur': 'Fatou B.',
        'montant': 18000,
        'statut': 'fonds_bloques',
        'created_at': DateTime.now().subtract(const Duration(minutes: 45)).toIso8601String(),
      },
    ];
  }

  /// Valide la réception (scan QR ou OTP)
  Future<Map<String, dynamic>> validateReception({
    required String transactionId,
    String? qrCode,
    String? otpCode,
  }) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'message': 'Transaction validée ! Vendeur et livreur payés automatiquement.',
      'transaction': {
        'id': transactionId,
        'statut': 'livre_valide',
        'validated_at': DateTime.now().toIso8601String(),
      },
    };

    // REAL:
    // final response = await _api.post('/transactions/$transactionId/validate', data: { ... });
    // return response.data;
  }

  /// Signale un litige
  Future<Map<String, dynamic>> signalerLitige({
    required String transactionId,
    required String raison,
    List<String>? photoPaths,
  }) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Litige signalé. Les fonds sont gelés. Notre équipe va analyser la situation.',
      'dispute': {
        'id': 'disp-001',
        'transaction_id': transactionId,
        'statut': 'ouvert',
      },
    };
  }
}
