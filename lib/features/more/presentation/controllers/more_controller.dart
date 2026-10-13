import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../data/repository/more_repository_impl.dart';

class MoreController extends Notifier<List<MenuItemEntity>> {
  @override
  List<MenuItemEntity> build() {
    final repo = ref.read(moreRepositoryProvider);
    return repo.getMenuItems();
  }

  Future<void> logout() async {
    final repo = ref.read(moreRepositoryProvider);
    await repo.logout();
  }
}
