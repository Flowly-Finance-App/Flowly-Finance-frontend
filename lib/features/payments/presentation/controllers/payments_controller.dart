import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_entity.dart';
import '../../data/repository/payments_repository_impl.dart';

class PaymentsController extends AsyncNotifier<List<PaymentEntity>> {
  @override
  FutureOr<List<PaymentEntity>> build() async {
    return _fetch();
  }

  Future<List<PaymentEntity>> _fetch() async {
    final repo = ref.read(paymentsRepositoryProvider);
    return repo.fetchPaymentHistory();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> makePayment({
    required String loanId,
    required double amount,
  }) async {
    final repo = ref.read(paymentsRepositoryProvider);
    await repo.makePayment(loanId: loanId, amount: amount);
    await refresh();
  }
}
