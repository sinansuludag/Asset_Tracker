import 'package:cloud_firestore/cloud_firestore.dart';

class AssetSummaryModel {
  final String id;
  final String userId;
  final String assetType;
  final String assetSubType;
  final double totalQuantity;
  final double totalInvestment;
  final double averagePrice;
  final double? totalGramWeight;
  final String? ayarType;
  final int transactionCount;
  final DateTime lastUpdated;

  AssetSummaryModel({
    required this.id,
    required this.userId,
    required this.assetType,
    required this.assetSubType,
    required this.totalQuantity,
    required this.totalInvestment,
    required this.averagePrice,
    this.totalGramWeight,
    this.ayarType,
    required this.transactionCount,
    required this.lastUpdated,
  });

  factory AssetSummaryModel.fromJson(Map<String, dynamic> json) {
    return AssetSummaryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      assetType: json['assetType'] ?? '',
      assetSubType: json['assetSubType'] ?? 'normal',
      totalQuantity: (json['totalQuantity'] ?? 0).toDouble(),
      totalInvestment: (json['totalInvestment'] ?? 0).toDouble(),
      averagePrice: (json['averagePrice'] ?? 0).toDouble(),
      totalGramWeight: json['totalGramWeight']?.toDouble(),
      ayarType: json['ayarType'],
      transactionCount: json['transactionCount'] ?? 1,
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'assetType': assetType,
      'assetSubType': assetSubType,
      'totalQuantity': totalQuantity,
      'totalInvestment': totalInvestment,
      'averagePrice': averagePrice,
      'totalGramWeight': totalGramWeight,
      'ayarType': ayarType,
      'transactionCount': transactionCount,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
