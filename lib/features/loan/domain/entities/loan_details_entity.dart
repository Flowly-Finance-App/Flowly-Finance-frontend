class LoanDetailsEntity {
  final String loanId;
  final String status;
  final double loanAmount;
  final double outstandingAmount;
  final double emiAmount;
  final int tenureMonths;
  final int monthsPaid;
  final List<String> documentUrls;

  const LoanDetailsEntity({
    required this.loanId,
    required this.status,
    required this.loanAmount,
    required this.outstandingAmount,
    required this.emiAmount,
    required this.tenureMonths,
    required this.monthsPaid,
    required this.documentUrls,
  });

  factory LoanDetailsEntity.fromJson(Map<String, dynamic> json) {
    return LoanDetailsEntity(
      loanId: (json['loanId'] ?? json['id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      loanAmount: _toDouble(json['loanAmount']),
      outstandingAmount: _toDouble(json['outstandingAmount']),
      emiAmount: _toDouble(json['emiAmount']),
      tenureMonths: _toInt(json['tenureMonths']),
      monthsPaid: _toInt(json['monthsPaid']),
      documentUrls: _toStringList(json['documentUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanId': loanId,
      'status': status,
      'loanAmount': loanAmount,
      'outstandingAmount': outstandingAmount,
      'emiAmount': emiAmount,
      'tenureMonths': tenureMonths,
      'monthsPaid': monthsPaid,
      'documentUrls': documentUrls,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
}

typedef LoanDetails = LoanDetailsEntity;
