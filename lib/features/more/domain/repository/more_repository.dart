import '../entities/menu_item_entity.dart';

abstract class MoreRepository {
  List<MenuItemEntity> getMenuItems();
  Future<void> logout();
}
