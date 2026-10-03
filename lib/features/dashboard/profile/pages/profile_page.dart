import 'package:flutter/material.dart';

// Store
import '../store/profile_controller.dart';

// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Perfil',
      child: AnimatedBuilder(
        animation: ProfileController.instance,
        builder: (context, _) => SingleChildScrollView(
          child: Form(key: _formKey, child: Column()),
        ),
      ),
    );
  }
}
