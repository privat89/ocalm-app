/// Grille tarifaire OCALM
/// L'acheteur paie les frais. Le vendeur ne paie RIEN.
class OcalmFees {
  OcalmFees._();

  /// Calcule les frais OCALM selon le montant de la transaction
  static int calculateFees(int montantArticle) {
    if (montantArticle <= 10000) return 100;
    if (montantArticle <= 30000) return 300;
    if (montantArticle <= 100000) return 500;
    if (montantArticle <= 500000) return 1000;
    return 2500;
  }

  /// Montant total que l'acheteur doit payer (article + frais)
  static int totalAcheteur(int montantArticle, {int fraisLivraison = 0}) {
    return montantArticle + calculateFees(montantArticle) + fraisLivraison;
  }

  /// Grille tarifaire pour affichage
  static const List<Map<String, dynamic>> grille = [
    {'min': 0, 'max': 10000, 'frais': 100},
    {'min': 10001, 'max': 30000, 'frais': 300},
    {'min': 30001, 'max': 100000, 'frais': 500},
    {'min': 100001, 'max': 500000, 'frais': 1000},
    {'min': 500001, 'max': null, 'frais': 2500},
  ];
}

/// Statuts possibles d'une transaction
enum TransactionStatus {
  enAttentePaiement('en_attente_paiement', 'En attente de paiement'),
  fondsBloques('fonds_bloques', 'Fonds verrouillés'),
  enLivraison('en_livraison', 'En livraison'),
  livreValide('livre_valide', 'Livré et validé'),
  litige('litige', 'En litige'),
  rembourse('rembourse', 'Remboursé');

  const TransactionStatus(this.value, this.label);
  final String value;
  final String label;
}

/// Rôles utilisateur
enum UserRole {
  acheteur('acheteur', 'Acheteur'),
  vendeur('vendeur', 'Vendeur'),
  livreur('livreur', 'Livreur');

  const UserRole(this.value, this.label);
  final String value;
  final String label;
}
