import 'package:flutter/material.dart';

sealed class SidebarEntry {
  const SidebarEntry();
}

class SidebarItem extends SidebarEntry {
  final String title;
  final IconData icon;
  final String? route;
  final String? permission;
  final int? badge;
  final List<SidebarItem> children;

  const SidebarItem({
    required this.title,
    required this.icon,
    this.route,
    this.permission,
    this.badge,
    this.children = const [],
  });
}

class SidebarSection extends SidebarEntry {
  final String? label;
  final List<SidebarItem> items;

  const SidebarSection({this.label, required this.items});
}

typedef SidebarMenu = List<SidebarEntry>;
