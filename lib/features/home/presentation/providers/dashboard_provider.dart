import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../controllers/dashboard_controller.dart';

final dashboardProvider =
    AsyncNotifierProvider<DashboardController, DashboardEntity>(
  DashboardController.new,
);