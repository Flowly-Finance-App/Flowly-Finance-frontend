import '../entities/payment_entity.dart';

abstract class PaymentsRepository {
  Future<List<PaymentEntity>> fetchPaymentHistory();
  Future<void> makePayment({required String loanId, required double amount});
}
