import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/kyc_entity.dart';
import '../controllers/kyc_form_controller.dart';

final kycFormProvider = NotifierProvider<KycFormController, KycFormState>(
  KycFormController.new,
);