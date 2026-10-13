import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FdCalculatorState {
  final double depositAmount;
  final double interestRate;
  final int tenureYears;
  final double maturityAmount;
  final double totalInterest;

  const FdCalculatorState({
    this.depositAmount = 50000,
    this.interestRate = 7,
    this.tenureYears = 1,
    this.maturityAmount = 0,
    this.totalInterest = 0,
  });

  FdCalculatorState copyWith({
    double? depositAmount,
    double? interestRate,
    int? tenureYears,
    double? maturityAmount,
    double? totalInterest,
  }) {
    return FdCalculatorState(
      depositAmount: depositAmount ?? this.depositAmount,
      interestRate: interestRate ?? this.interestRate,
      tenureYears: tenureYears ?? this.tenureYears,
      maturityAmount: maturityAmount ?? this.maturityAmount,
      totalInterest: totalInterest ?? this.totalInterest,
    );
  }
}

class FdCalculatorNotifier extends Notifier<FdCalculatorState> {
  @override
  FdCalculatorState build() {
    return _calculated(const FdCalculatorState());
  }

  void updateDepositAmount(double amount) {
    state = _calculated(state.copyWith(depositAmount: amount));
  }

  void updateInterestRate(double rate) {
    state = _calculated(state.copyWith(interestRate: rate));
  }

  void updateTenureYears(int years) {
    state = _calculated(state.copyWith(tenureYears: years));
  }

  FdCalculatorState _calculated(FdCalculatorState s) {
    final p = s.depositAmount;
    final r = s.interestRate / 100;
    final t = s.tenureYears;
    const n = 4; // quarterly compounding

    if (p <= 0 || r <= 0 || t <= 0) {
      return s.copyWith(maturityAmount: 0, totalInterest: 0);
    }

    final maturity = p * pow(1 + r / n, n * t);
    final interest = maturity - p;

    return s.copyWith(
      maturityAmount: maturity.toDouble(),
      totalInterest: interest.toDouble(),
    );
  }
}

final fdCalculatorProvider =
    NotifierProvider<FdCalculatorNotifier, FdCalculatorState>(
  FdCalculatorNotifier.new,
);