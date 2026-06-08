import 'api_service.dart';

/// Service de paiement Mobile Money (Wave en Phase 1)
class WalletService {
  final ApiService _api;

  WalletService(this._api);

  /// Initie un paiement Wave pour une transaction
  Future<Map<String, dynamic>> initiatePayment({
    required String transactionId,
    required int amount,
    required String phone,
  }) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'payment': {
        'id': 'pay-${DateTime.now().millisecondsSinceEpoch}',
        'transaction_id': transactionId,
        'amount': amount,
        'phone': phone,
        'operator': 'wave',
        'status': 'pending',
        'checkout_url': 'https://pay.wave.com/c/mock-checkout',
      },
      'message': 'Demande de paiement envoyée. Confirme sur ton téléphone.',
    };

    // REAL:
    // final response = await _api.post('/wallet/pay', data: { ... });
    // return response.data;
  }

  /// Vérifie le statut d'un paiement
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentId) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    return {
      'payment_id': paymentId,
      'status': 'completed', // pending, completed, failed
      'completed_at': DateTime.now().toIso8601String(),
    };

    // REAL:
    // final response = await _api.get('/wallet/status/$paymentId');
    // return response.data;
  }

  /// Récupère le solde du wallet OCALM de l'utilisateur
  Future<Map<String, dynamic>> getBalance() async {
    // MOCK
    return {
      'available': 0, // OCALM ne garde pas l'argent
      'in_escrow': 75000, // montant en séquestre
      'total_earned': 185000, // gains totaux (vendeur/livreur)
    };
  }

  /// Historique des paiements
  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 'pay-001',
        'type': 'escrow_deposit',
        'amount': 35000,
        'status': 'completed',
        'date': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'description': 'Dépôt séquestre — Samsung Galaxy A14',
      },
      {
        'id': 'pay-002',
        'type': 'seller_payout',
        'amount': 25000,
        'status': 'completed',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'description': 'Paiement vendeur — Box Internet 4G',
      },
      {
        'id': 'pay-003',
        'type': 'delivery_payout',
        'amount': 1500,
        'status': 'completed',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'description': 'Paiement livreur — Course #145',
      },
    ];
  }
}
