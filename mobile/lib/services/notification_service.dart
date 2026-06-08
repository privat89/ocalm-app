import 'api_service.dart';

/// Service de notifications (Push + SMS)
class NotificationService {
  final ApiService _api;

  NotificationService(this._api);

  /// Récupère les notifications de l'utilisateur
  Future<List<Map<String, dynamic>>> getNotifications() async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 'notif-001',
        'type': 'escrow_locked',
        'title': 'Fonds sécurisés',
        'body': 'Privat M. a payé 35 000 F pour votre Samsung Galaxy A14. Vous pouvez livrer !',
        'read': false,
        'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      },
      {
        'id': 'notif-002',
        'type': 'delivery_pickup',
        'title': 'Colis pris en charge',
        'body': 'Le livreur Koné A. a récupéré votre colis. Suivi en temps réel activé.',
        'read': false,
        'created_at': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        'id': 'notif-003',
        'type': 'payment_received',
        'title': 'Paiement reçu !',
        'body': 'Vous avez reçu 25 000 F pour votre vente "Box Internet 4G". Merci !',
        'read': true,
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'notif-004',
        'type': 'delivery_complete',
        'title': 'Livraison confirmée',
        'body': 'L\'acheteur a confirmé la réception. Votre paiement de 1 500 F est en route.',
        'read': true,
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];
  }

  /// Marque une notification comme lue
  Future<void> markAsRead(String notifId) async {
    // MOCK
    // REAL: await _api.put('/notifications/$notifId/read');
  }

  /// Enregistre le token FCM
  Future<void> registerFCMToken(String token) async {
    // REAL: await _api.post('/notifications/register', data: {'fcm_token': token});
  }
}
