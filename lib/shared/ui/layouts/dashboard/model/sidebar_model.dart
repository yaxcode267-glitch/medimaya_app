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

  /// El módulo todavía no tiene API en el backend, así que no hay ruta
  /// registrada a la que navegar. Se muestra con una etiqueta para que el menú
  /// describa el roadmap sin romper la navegación.
  final bool comingSoon;

  const SidebarItem({
    required this.title,
    required this.icon,
    this.route,
    this.permission,
    this.badge,
    this.children = const [],
    this.comingSoon = false,
  });
}

class SidebarSection extends SidebarEntry {
  final String? label;
  final List<SidebarItem> items;

  const SidebarSection({this.label, required this.items});
}

typedef SidebarMenu = List<SidebarEntry>;
