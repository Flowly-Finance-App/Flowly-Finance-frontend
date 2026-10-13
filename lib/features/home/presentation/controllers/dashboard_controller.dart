import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../data/repository/dashboard_repository_impl.dart';

class DashboardController extends AsyncNotifier<DashboardEntity> {
  @override
  FutureOr<DashboardEntity> build() async {
    return _fetch();
  }

  Future<DashboardEntity> _fetch() async {
    final repo = ref.read(dashboardRepositoryProvider);
    return repo.fetchDashboard();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
