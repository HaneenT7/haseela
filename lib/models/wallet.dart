import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String id;
  final double totalBalance;
  final double savingsBalance;
  final double spendingsBalance;
  final int streakCount;
  final DateTime lastUpdated;

  Wallet({
    required this.id,
    required this.totalBalance,
    required this.savingsBalance,
    required this.spendingsBalance,
    required this.streakCount,
    required this.lastUpdated,
  });

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Wallet(
      id: doc.id,
      totalBalance: (data['totalBalance'] ?? 0).toDouble(),
      savingsBalance: (data['savingsBalance'] ?? 0).toDouble(),
      spendingsBalance: (data['spendingsBalance'] ?? 0).toDouble(),
      streakCount: data['streakCount'] ?? 0,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
