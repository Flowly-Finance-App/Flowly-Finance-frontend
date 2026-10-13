import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/loan_details_entity.dart';
import '../controllers/loan_details_controller.dart';

final loanDetailsProvider = AsyncNotifierProvider.family<
    LoanDetailsController,
    LoanDetailsEntity,
    String>(
  LoanDetailsController.new,
);