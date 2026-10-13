import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/repository/more_repository.dart';
import '../datasource/more_remote_datasource.dart';

class MoreRepositoryImpl implements MoreRepository {
  final MoreRemoteDataSource _remote;

  MoreRepositoryImpl(this._remote);

  @override
  List<MenuItemEntity> getMenuItems() {
    return const [
      MenuItemEntity(
        id: 'profile',
        title: 'Profile',
        subtitle: 'Manage personal details',
        icon: Icons.person_outline,
      ),
      MenuItemEntity(
        id: 'kyc',
        title: 'KYC Verification',
        subtitle: 'View KYC status & documents',
        icon: Icons.verified_user_outlined,
      ),
      MenuItemEntity(
        id: 'security',
        title: 'Security',
        subtitle: 'Change MPIN and password',
        icon: Icons.security_outlined,
      ),
      MenuItemEntity(
        id: 'support',
        title: 'Help & Support',
        subtitle: 'FAQs and customer care',
        icon: Icons.help_outline,
      ),
    ];
  }

  @override
  Future<void> logout() {
    return _remote.logout();
  }
}

final moreRepositoryProvider = Provider<MoreRepository>((ref) {
  final remote = ref.watch(moreRemoteDataSourceProvider);
  return MoreRepositoryImpl(remote);
});
