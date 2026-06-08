import 'api_service.dart';

/// Service de livraison — QR codes, tracking, statuts
class DeliveryService {
  final ApiService _api;

  DeliveryService(this._api);

  /// Génère un QR code pour le départ (vendeur → livreur)
  Future<Map<String, dynamic>> generateDepartureQR(String transactionId) async {
    // MOCK
    return {
      'qr_data': 'ocalm:depart:$transactionId:${DateTime.now().millisecondsSinceEpoch}',
      'expires_at': DateTime.now().add(const Duration(hours: 4)).toIso8601String(),
    };
  }

  /// Génère un QR code pour l'arrivée (livreur → acheteur)
  Future<Map<String, dynamic>> generateArrivalQR(String transactionId) async {
    // MOCK
    return {
      'qr_data': 'ocalm:arrive:$transactionId:${DateTime.now().millisecondsSinceEpoch}',
      'otp_code': '847291', // Code OTP secours
      'expires_at': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
    };
  }

  /// Scanne le QR code de départ
  Future<Map<String, dynamic>> scanDeparture(String qrData) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Colis pris en charge !',
      'transaction_status': 'en_livraison',
    };
  }

  /// Scanne le QR code d'arrivée ou valide par OTP
  Future<Map<String, dynamic>> scanArrival({
    String? qrData,
    String? otpCode,
    required String transactionId,
  }) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Livraison confirmée ! Paiements en cours...',
      'payouts': {
        'vendeur': {'amount': 35000, 'status': 'processing'},
        'livreur': {'amount': 1500, 'status': 'processing'},
        'ocalm_fees': {'amount': 300, 'status': 'collected'},
      },
    };
  }

  /// Récupère les courses disponibles pour un livreur
  Future<List<Map<String, dynamic>>> getAvailableCourses({
    double? latitude,
    double? longitude,
  }) async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {
        'id': 'course-001',
        'pickup': 'Cocody Angré',
        'pickup_lat': 5.3691,
        'pickup_lng': -3.9587,
        'drop': 'Yopougon Maroc',
        'drop_lat': 5.3411,
        'drop_lng': -4.0665,
        'distance_km': 8.2,
        'gain': 2000,
        'article': 'Colis moyen',
      },
      {
        'id': 'course-002',
        'pickup': 'Treichville Gare',
        'pickup_lat': 5.3054,
        'pickup_lng': -3.9985,
        'drop': 'Marcory Zone 4',
        'drop_lat': 5.3085,
        'drop_lng': -3.9780,
        'distance_km': 3.1,
        'gain': 1200,
        'article': 'Petit colis',
      },
      {
        'id': 'course-003',
        'pickup': 'Adjamé Forum',
        'pickup_lat': 5.3495,
        'pickup_lng': -4.0200,
        'drop': 'Plateau Cathédrale',
        'drop_lat': 5.3231,
        'drop_lng': -4.0171,
        'distance_km': 5.7,
        'gain': 1500,
        'article': 'Colis moyen',
      },
    ];
  }

  /// Accepte une course
  Future<Map<String, dynamic>> acceptCourse(String courseId) async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'course': {
        'id': courseId,
        'status': 'accepted',
        'message': 'Course acceptée ! Rendez-vous au point de pickup.',
      },
    };
  }

  /// Met à jour la position du livreur
  Future<void> updatePosition(double lat, double lng) async {
    // MOCK — en réalité envoie la position au backend
    // await _api.post('/delivery/position', data: {'lat': lat, 'lng': lng});
  }
}
