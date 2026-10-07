import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/model/sidebar_model.dart';

const SidebarMenu sidebarMenu = [
  SidebarItem(
    title: 'Usuarios',
    icon: Icons.group_outlined,
    route: '/dashboard/users',
    permission: 'users:view',
  ),
  SidebarItem(
    title: 'Roles',
    icon: Icons.privacy_tip,
    route: '/dashboard/roles',
    permission: 'roles:view',
  ),
  SidebarSection(
    label: 'Punto de venta',
    items: [
      SidebarItem(
        title: 'Categorías',
        icon: Icons.category_outlined,
        route: '/dashboard/pos/inventory/categories',
        permission: 'product-categories:view',
      ),
      SidebarItem(
        title: 'Productos',
        icon: Icons.inventory_2_outlined,
        route: '/dashboard/pos/inventory/products',
        permission: 'products:view',
      ),
    ],
  ),
];
