enum LoanType { personal, home, vehicle, education, business }

extension LoanTypeLabel on LoanType {
  String get label {
    switch (this) {
      case LoanType.personal:
        return 'Personal Loan';
      case LoanType.home:
        return 'Home Loan';
      case LoanType.vehicle:
        return 'Vehicle Loan';
      case LoanType.education:
        return 'Education Loan';
      case LoanType.business:
        return 'Business Loan';
    }
  }

  String get subtitle {
    switch (this) {
      case LoanType.personal:
        return 'For Personal Needs';
      case LoanType.home:
        return 'For Your Dream Home';
      case LoanType.vehicle:
        return 'For Your Dream Vehicle';
      case LoanType.education:
        return 'For Your Education';
      case LoanType.business:
        return 'Grow Your Business';
    }
  }
}