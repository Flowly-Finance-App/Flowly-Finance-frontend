import 'package:flowly_finance_app/features/apply/domain/entities/application_result_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/submit_application_controller.dart';

final submitApplicationProvider =
    AsyncNotifierProvider<SubmitApplicationController, ApplicationResult?>(
  SubmitApplicationController.new,
);