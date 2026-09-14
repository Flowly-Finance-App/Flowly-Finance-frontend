import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/register_controller.dart';

final registerProvider = AsyncNotifierProvider<RegisterController, void>(
  RegisterController.new,
);