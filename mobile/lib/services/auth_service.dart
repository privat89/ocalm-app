import 'api_service.dart';

/// Service d'authentification — Login par téléphone + OTP
class AuthService {
  final ApiService _api;

  AuthService(this._api);

  /// Envoie un OTP au numéro de téléphone
  Future<Map<String, dynamic>> sendOTP(String phone) async {
    // MOCK: En attendant le backend
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'OTP envoyé à $phone'};

    // REAL:
    // final response = await _api.post('/auth/send-otp', data: {'phone': phone});
    // return response.data;
  }

  /// Vérifie le code OTP
  Future<Map<String, dynamic>> verifyOTP(String phone, String code) async {
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    if (code == '123456') {
      return {
        'success': true,
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock_refresh_token',
        'user': {
          'id': 'user-001',
          'phone': phone,
          'name': 'Privat',
          'role': null, // pas encore choisi
        },
      };
    }
    return {'success': false, 'message': 'Code invalide'};

    // REAL:
    // final response = await _api.post('/auth/verify-otp', data: {'phone': phone, 'code': code});
    // return response.data;
  }

  /// Définit le rôle de l'utilisateur
  Future<Map<String, dynamic>> setRole(String userId, String role) async {
    // MOCK
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'role': role};

    // REAL:
    // final response = await _api.put('/auth/role', data: {'userId': userId, 'role': role});
    // return response.data;
  }

  /// Rafraîchit le token JWT
  Future<String?> refreshToken(String refreshToken) async {
    // MOCK
    return 'new_mock_jwt_token';

    // REAL:
    // final response = await _api.post('/auth/refresh', data: {'refreshToken': refreshToken});
    // return response.data['token'];
  }
}
