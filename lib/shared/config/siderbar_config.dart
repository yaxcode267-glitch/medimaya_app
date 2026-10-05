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
    label: 'Clínico',
    items: [
      SidebarItem(
        title: 'Formularios de consulta',
        icon: Icons.assignment_outlined,
        route: '/dashboard/consultation-forms',
        permission: 'consultation-forms:view',
        comingSoon: true,
      ),
      SidebarItem(
        title: 'Campos de consulta',
        icon: Icons.list_alt_outlined,
        route: '/dashboard/consultation-fields',
        permission: 'consultation-fields:view',
        comingSoon: true,
      ),
      SidebarItem(
        title: 'Especialidades',
        icon: Icons.medical_services_outlined,
        route: '/dashboard/specialties',
        permission: 'specialties:view',
        comingSoon: true,
      ),
    ],
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
        route: '/pos/inventory/products',
        permission: 'products:view',
        comingSoon: true,
      ),
    ],
  ),
];
