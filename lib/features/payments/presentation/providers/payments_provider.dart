import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_entity.dart';
import '../controllers/payments_controller.dart';

final paymentsProvider =
    AsyncNotifierProvider<PaymentsController, List<PaymentEntity>>(
  PaymentsController.new,
);
