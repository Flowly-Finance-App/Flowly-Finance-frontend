import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../controllers/more_controller.dart';

final moreMenuProvider =
    NotifierProvider<MoreController, List<MenuItemEntity>>(
  MoreController.new,
);
