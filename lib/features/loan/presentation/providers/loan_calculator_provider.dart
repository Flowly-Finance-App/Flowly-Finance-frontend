import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanCalculatorState {
  final double loanAmount;
  final double interestRate;
  final int tenureMonths;
  final double emi;
  final double totalInterest;
  final double totalPayable;

  const LoanCalculatorState({
    this.loanAmount = 100000,
    this.interestRate = 10,
    this.tenureMonths = 12,
    this.emi = 0,
    this.totalInterest = 0,
    this.totalPayable = 0,
  });

  LoanCalculatorState copyWith({
    double? loanAmount,
    double? interestRate,
    int? tenureMonths,
    double? emi,
    double? totalInterest,
    double? totalPayable,
  }) {
    return LoanCalculatorState(
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      emi: emi ?? this.emi,
      totalInterest: totalInterest ?? this.totalInterest,
      totalPayable: totalPayable ?? this.totalPayable,
    );
  }
}

class LoanCalculatorNotifier extends Notifier<LoanCalculatorState> {
  @override
  LoanCalculatorState build() {
    final initial = const LoanCalculatorState();
    return _calculated(initial);
  }

  void updateAmount(double amount) {
    state = _calculated(state.copyWith(loanAmount: amount));
  }

  void updateInterestRate(double rate) {
    state = _calculated(state.copyWith(interestRate: rate));
  }

  void updateTenureMonths(int months) {
    state = _calculated(state.copyWith(tenureMonths: months));
  }

  LoanCalculatorState _calculated(LoanCalculatorState s) {
    final p = s.loanAmount;
    final r = s.interestRate / 12 / 100;
    final n = s.tenureMonths;

    if (p <= 0 || r <= 0 || n <= 0) {
      return s.copyWith(emi: 0, totalInterest: 0, totalPayable: 0);
    }

    final factor = pow(1 + r, n);
    final emi = (p * r * factor) / (factor - 1);
    final totalPayable = emi * n;
    final totalInterest = totalPayable - p;

    return s.copyWith(
      emi: emi,
      totalInterest: totalInterest,
      totalPayable: totalPayable,
    );
  }
}

final loanCalculatorProvider =
    NotifierProvider<LoanCalculatorNotifier, LoanCalculatorState>(
  LoanCalculatorNotifier.new,
);