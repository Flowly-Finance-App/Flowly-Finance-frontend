import 'package:flutter/material.dart';

class NavItemEntity {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemEntity({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
