class PaymentEntity {
  final String id;
  final String loanId;
  final double amount;
  final String status;
  final DateTime dueDate;
  final DateTime? paidDate;

  const PaymentEntity({
    required this.id,
    required this.loanId,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
  });

  factory PaymentEntity.fromJson(Map<String, dynamic> json) {
    return PaymentEntity(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      loanId: (json['loanId'] ?? '').toString(),
      amount: (json['amount'] ?? 0).toDouble(),
      status: (json['status'] ?? '').toString(),
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paidDate: json['paidDate'] != null
          ? DateTime.tryParse(json['paidDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
    };
  }
}
