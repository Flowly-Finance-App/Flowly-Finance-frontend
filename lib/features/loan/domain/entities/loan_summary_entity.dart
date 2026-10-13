class LoanSummaryEntity {
  final String loanId;
  final double loanAmount;
  final double outstandingAmount;
  final double emiAmount;
  final double interestRate;
  final int tenureMonths;
  final String nextEmiDate;

  const LoanSummaryEntity({
    required this.loanId,
    required this.loanAmount,
    required this.outstandingAmount,
    required this.emiAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.nextEmiDate,
  });

  factory LoanSummaryEntity.fromJson(Map<String, dynamic> json) {
    return LoanSummaryEntity(
      loanId: json['loanId']?.toString() ?? '',
      loanAmount: (json['loanAmount'] ?? 0).toDouble(),
      outstandingAmount: (json['outstandingAmount'] ?? 0).toDouble(),
      emiAmount: (json['emiAmount'] ?? 0).toDouble(),
      interestRate: (json['interestRate'] ?? 0).toDouble(),
      tenureMonths: (json['tenureMonths'] ?? 0) is int
          ? json['tenureMonths'] as int
          : int.tryParse(json['tenureMonths']?.toString() ?? '0') ?? 0,
      nextEmiDate: json['nextEmiDate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanId': loanId,
      'loanAmount': loanAmount,
      'outstandingAmount': outstandingAmount,
      'emiAmount': emiAmount,
      'interestRate': interestRate,
      'tenureMonths': tenureMonths,
      'nextEmiDate': nextEmiDate,
    };
  }
}

typedef LoanSummary = LoanSummaryEntity;
