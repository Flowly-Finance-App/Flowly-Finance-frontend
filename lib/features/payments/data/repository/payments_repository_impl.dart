import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repository/payments_repository.dart';
import '../datasource/payments_remote_datasource.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource _remote;

  PaymentsRepositoryImpl(this._remote);

  @override
  Future<List<PaymentEntity>> fetchPaymentHistory() async {
    final rawList = await _remote.fetchPaymentHistory();
    return rawList.map(PaymentEntity.fromJson).toList();
  }

  @override
  Future<void> makePayment({required String loanId, required double amount}) {
    return _remote.makePayment(loanId: loanId, amount: amount);
  }
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  final remote = ref.watch(paymentsRemoteDataSourceProvider);
  return PaymentsRepositoryImpl(remote);
});
