import 'package:flutter/material.dart';

// Model
import '../model/role.model.dart';
import '../model/permission.model.dart';
// Service
import '../service/roles_service.dart';
// Widget Propios
import '../widget/permissions_selector.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/forms/form_actions.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class RolesCreatePage extends StatefulWidget {
  const RolesCreatePage({super.key});

  @override
  State<RolesCreatePage> createState() => _RolesCreatePageState();
}

class _RolesCreatePageState extends State<RolesCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _service = RolesService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<PermissionGroup> _groups = [];
  List<String> _selectedPermissions = [];

  bool _loadingPermissions = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPermissions() async {
    try {
      final groups = await _service.permissions();

      if (!mounted) return;

      setState(() {
        _groups = groups;
        _loadingPermissions = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingPermissions = false;
      });
    }
  }

  Future<void> _createRole() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      final payload = RolePayload(
        name: name,
        description: description.isEmpty ? null : description,
        permissions: _selectedPermissions,
      );

      await _service.create(payload);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Crear rol',
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInput(
                name: 'Nombre del rol',
                controller: _nameController,
                required: true,
                hint: 'Ej. Administrador',
              ),

              const SizedBox(height: 16),

              AppInput(
                name: 'Descripción',
                controller: _descriptionController,
                maxLines: 4,
                hint: 'Describe las funciones de este rol',
              ),

              const SizedBox(height: 24),

              PermissionsSelector(
                groups: _groups,
                selected: _selectedPermissions,
                loading: _loadingPermissions,
                onChanged: (permissions) {
                  setState(() {
                    _selectedPermissions = permissions;
                  });
                },
              ),

              const SizedBox(height: 24),

              FormActions(
                saveFlex: 1,
                cancel: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    style: ButtonThemes.secondary(),
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                save: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ButtonThemes.primary(),
                    onPressed: _saving ? null : _createRole,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Crear rol'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
