class TransactionModel {
  final int transactionId;
  final double amount;
  final String currency;
  final int? pointOfferId;
  final int offerNum;
  final bool inOffer;
  final int status;
  final String gateway;
  final String? gatewayTransactionId;
  final DateTime createdAt;
  final String userId;

  TransactionModel({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.pointOfferId,
    required this.offerNum,
    required this.inOffer,
    required this.status,
    required this.gateway,
    required this.gatewayTransactionId,
    required this.createdAt,
    required this.userId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json["transaction_Id"] as int? ?? 0,
      amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
      currency: json["currency"] as String? ?? "",
      pointOfferId: json["point_Offer_Id"] as int?,
      offerNum: json["offer_Num"] as int? ?? 0,
      inOffer: json["in_Offer"] as bool? ?? false,
      status: json["status"] as int? ?? 0,
      gateway: json["gateway"] as String? ?? "",
      gatewayTransactionId: json["gatewayTransactionId"] as String?,
      createdAt:
          DateTime.tryParse(json["created_At"] as String? ?? "") ?? DateTime(0),
      userId: json["user_Id"] as String? ?? "",
    );
  }
}
