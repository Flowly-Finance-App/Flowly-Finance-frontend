import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/enter_mpin_controller.dart';

final enterMpinProvider = AsyncNotifierProvider<EnterMpinController, bool>(
  EnterMpinController.new,
);