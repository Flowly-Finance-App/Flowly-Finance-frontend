import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/reset_mpin_controller.dart';

final resetMpinProvider = AsyncNotifierProvider<ResetMpinController, void>(
  ResetMpinController.new,
);