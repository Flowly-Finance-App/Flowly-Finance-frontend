class ApplicationResult {
  final String applicationId;
  final String submittedOn;
  final double requestAmount;
  final int tenureMonths;
  final String status;

  ApplicationResult({
    required this.applicationId,
    required this.submittedOn,
    required this.requestAmount,
    required this.tenureMonths,
    required this.status,
  });

  factory ApplicationResult.fromJson(Map<String, dynamic> json) {
    return ApplicationResult(
      applicationId: json['applicationId'] ?? '-',
      submittedOn: json['submittedOn'] ?? '-',
      requestAmount: (json['requestAmount'] ?? 0).toDouble(),
      tenureMonths: json['tenureMonths'] ?? 0,
      status: json['status'] ?? 'under_review',
    );
  }
}