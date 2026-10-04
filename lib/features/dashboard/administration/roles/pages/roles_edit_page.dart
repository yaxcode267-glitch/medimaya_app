import 'package:flutter/material.dart';

// Model
import '../model/permission.model.dart';
import '../model/role.model.dart';
import '../model/role_detail_model.dart';
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

class RolesEditPage extends StatefulWidget {
  const RolesEditPage({super.key, required this.id});

  final String id;

  @override
  State<RolesEditPage> createState() => _RolesEditPageState();
}

class _RolesEditPageState extends State<RolesEditPage> {
  final _formKey = GlobalKey<FormState>();

  final _service = RolesService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<PermissionGroup> _groups = [];
  List<String> _selectedPermissions = [];

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _service.get(widget.id),
        _service.permissions(),
      ]);
      final detail = results[0] as RoleDetail;
      final groups = results[1] as List<PermissionGroup>;

      if (!mounted) return;

      setState(() {
        _nameController.text = detail.name;
        _descriptionController.text = detail.description ?? '';
        _selectedPermissions = List.from(detail.permissions);
        _groups = groups;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
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

      await _service.update(widget.id, payload);

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
      title: 'Editar rol',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
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
                      loading: _groups.isEmpty,
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
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      save: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ButtonThemes.primary(),
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Guardar cambios'),
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
