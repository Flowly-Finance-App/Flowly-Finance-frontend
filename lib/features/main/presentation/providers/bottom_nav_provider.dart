import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bottom_nav_controller.dart';

export '../controllers/bottom_nav_controller.dart';

final bottomNavIndexProvider = NotifierProvider<BottomNavController, int>(
  BottomNavController.new,
);