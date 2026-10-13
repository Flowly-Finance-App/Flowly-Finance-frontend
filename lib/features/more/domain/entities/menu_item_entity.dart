import 'package:flutter/material.dart';

class MenuItemEntity {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? route;

  const MenuItemEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.route,
  });
}
