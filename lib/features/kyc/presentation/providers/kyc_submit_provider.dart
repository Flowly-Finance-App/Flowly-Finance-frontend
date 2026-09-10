import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/kyc_submit_controller.dart';

final kycSubmitProvider = AsyncNotifierProvider<KycSubmitController, void>(
  KycSubmitController.new,
);