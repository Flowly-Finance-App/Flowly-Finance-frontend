import 'loan_type.dart';

class ApplyLoanFormState {
  final LoanType loanType;
  final String fullName;
  final String mobile;
  final String email;
  final String dob;
  final String panNumber;
  final String employmentType;
  final String monthlyIncome;
  final String companyName;
  final String workExperience;
  final double loanAmount;
  final int tenureMonths;
  final double interestRate;
  final bool agreedToTerms;

  const ApplyLoanFormState({
    this.loanType = LoanType.personal,
    this.fullName = '',
    this.mobile = '',
    this.email = '',
    this.dob = '',
    this.panNumber = '',
    this.employmentType = '',
    this.monthlyIncome = '',
    this.companyName = '',
    this.workExperience = '',
    this.loanAmount = 200000,
    this.tenureMonths = 24,
    this.interestRate = 11.99,
    this.agreedToTerms = false,
  });

  double get estimatedEmi {
    final p = loanAmount;
    final r = interestRate / 12 / 100;
    final n = tenureMonths;
    if (p <= 0 || r <= 0 || n <= 0) return 0;
    final factor = _pow(1 + r, n);
    return (p * r * factor) / (factor - 1);
  }

  static double _pow(double base, int exponent) {
    double result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  ApplyLoanFormState copyWith({
    LoanType? loanType,
    String? fullName,
    String? mobile,
    String? email,
    String? dob,
    String? panNumber,
    String? employmentType,
    String? monthlyIncome,
    String? companyName,
    String? workExperience,
    double? loanAmount,
    int? tenureMonths,
    double? interestRate,
    bool? agreedToTerms,
  }) {
    return ApplyLoanFormState(
      loanType: loanType ?? this.loanType,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      panNumber: panNumber ?? this.panNumber,
      employmentType: employmentType ?? this.employmentType,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      companyName: companyName ?? this.companyName,
      workExperience: workExperience ?? this.workExperience,
      loanAmount: loanAmount ?? this.loanAmount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      interestRate: interestRate ?? this.interestRate,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanType': loanType.name,
      'fullName': fullName,
      'mobile': mobile,
      'email': email,
      'dob': dob,
      'panNumber': panNumber,
      'employmentType': employmentType,
      'monthlyIncome': monthlyIncome,
      'companyName': companyName,
      'workExperience': workExperience,
      'loanAmount': loanAmount,
      'tenureMonths': tenureMonths,
      'interestRate': interestRate,
    };
  }
}