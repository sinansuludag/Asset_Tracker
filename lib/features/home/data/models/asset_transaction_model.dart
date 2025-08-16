import 'package:cloud_firestore/cloud_firestore.dart';

class AssetTransactionModel {
  final String id;
  final String userId;
  final String assetType;
  final String assetSubType;
  final double quantity;
  final double buyingPrice;
  final DateTime buyingDate;
  final double totalInvestment;
  final double? gramWeight;
  final String? ayarType;
  final int transactionNumber;
  final DateTime createdAt;

  AssetTransactionModel({
    required this.id,
    required this.userId,
    required this.assetType,
    required this.assetSubType,
    required this.quantity,
    required this.buyingPrice,
    required this.buyingDate,
    required this.totalInvestment,
    this.gramWeight,
    this.ayarType,
    required this.transactionNumber,
    required this.createdAt,
  });

  factory AssetTransactionModel.fromJson(Map<String, dynamic> json) {
    return AssetTransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      assetType: json['assetType'] ?? '',
      assetSubType: json['assetSubType'] ?? 'normal',
      quantity: (json['quantity'] ?? 0).toDouble(),
      buyingPrice: (json['buyingPrice'] ?? 0).toDouble(),
      buyingDate: DateTime.parse(json['buyingDate']),
      totalInvestment: (json['totalInvestment'] ?? 0).toDouble(),
      gramWeight: json['gramWeight']?.toDouble(),
      ayarType: json['ayarType'],
      transactionNumber: json['transactionNumber'] ?? 1,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'assetType': assetType,
      'assetSubType': assetSubType,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'buyingDate': buyingDate.toIso8601String(),
      'totalInvestment': totalInvestment,
      'gramWeight': gramWeight,
      'ayarType': ayarType,
      'transactionNumber': transactionNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
