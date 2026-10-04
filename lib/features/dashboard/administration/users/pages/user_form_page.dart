import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/forms/form_actions.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

import '../model/user_model.dart';
import '../store/user_store.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key, this.id});
  final String? id;
  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final store = UserStore.instance;
  final form = GlobalKey<FormState>();
  final names = TextEditingController();
  final surnames = TextEditingController();
  final email = TextEditingController();
  List<UserRole> roles = [];
  UserDetail? user;
  String? roleId, error;
  bool loading = true, saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    names.dispose();
    surnames.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final detail = widget.id == null ? null : await store.detail(widget.id!);
      final options = await store.roles();
      if (!mounted) return;
      user = detail;
      roles = options;
      names.text = detail?.names ?? '';
      surnames.text = detail?.surnames ?? '';
      email.text = detail?.email ?? '';
      roleId = options.any((role) => role.id == detail?.roleId)
          ? detail?.roleId
          : null;
    } on DioException catch (e) {
      error = ApiError.fromDio(e).message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    if (saving || !form.currentState!.validate()) return;
    setState(() => saving = true);
    final saved = await store.save(
      UserInput(
        names: names.text,
        surnames: surnames.text,
        email: email.text,
        roleId: user?.roleLocked == true ? null : roleId,
      ),
      id: widget.id,
    );
    if (!mounted) return;
    setState(() => saving = false);
    if (saved) context.go('/dashboard/users');
  }

  String? _nameLength(String? value) =>
      (value?.trim().length ?? 0) > 100 ? 'Máximo 100 caracteres' : null;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: widget.id == null ? 'Nuevo usuario' : 'Editar usuario',
    child: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(
            child: AppEmptyState(icon: Icons.error_outline, message: error!),
          )
        : SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Datos del usuario',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.id == null
                        ? 'La contraseña se genera automáticamente y se envía por correo.'
                        : 'Actualiza los datos y el rol de acceso.',
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, box) {
                      final namesField = AppInput(
                        name: 'Nombres',
                        required: true,
                        controller: names,
                        hint: 'Ej. María Fernanda',
                        readOnly: saving,
                        validator: _nameLength,
                      );
                      final surnamesField = AppInput(
                        name: 'Apellidos',
                        required: true,
                        controller: surnames,
                        hint: 'Ej. López García',
                        readOnly: saving,
                        validator: _nameLength,
                      );
                      return box.maxWidth >= 560
                          ? Row(
                              children: [
                                Expanded(child: namesField),
                                const SizedBox(width: 16),
                                Expanded(child: surnamesField),
                              ],
                            )
                          : Column(
                              children: [
                                namesField,
                                const SizedBox(height: 16),
                                surnamesField,
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    name: 'Correo electrónico',
                    required: true,
                    controller: email,
                    hint: 'Ej. maria@medimaya.com',
                    prefixIcon: const Icon(Icons.alternate_email, size: 20),
                    readOnly: saving,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.length > 255) return 'Máximo 255 caracteres';
                      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(text)
                          ? null
                          : 'Ingresa un correo electrónico válido';
                    },
                  ),
                  const SizedBox(height: 16),
                  if (user?.roleLocked == true)
                    AppInput(
                      name: 'Rol',
                      initialValue: user?.roleName ?? 'Sin rol',
                      readOnly: true,
                      helperText:
                          'El rol del usuario principal no puede modificarse.',
                    )
                  else if (roles.isEmpty)
                    const AppEmptyState(
                      message: 'No hay roles activos disponibles. Se necesita un rol para guardar el usuario.',
                    )
                  else
                    _RoleSelector(
                      roles: roles,
                      value: roleId,
                      enabled: !saving,
                      onChanged: (value) => setState(() => roleId = value),
                    ),
                  const SizedBox(height: 24),
                  FormActions(
                    saveFlex: 1,
                    cancel: OutlinedButton(
                      style: ButtonThemes.secondary(),
                      onPressed: saving
                          ? null
                          : () => context.go('/dashboard/users'),
                      child: const Text('Cancelar'),
                    ),
                    save: FilledButton(
                      style: ButtonThemes.primary(),
                      onPressed:
                          saving || (roles.isEmpty && user?.roleLocked != true)
                          ? null
                          : _save,
                      child: Text(saving ? 'Guardando…' : 'Guardar usuario'),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.roles,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });
  final List<UserRole> roles;
  final String? value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => FormField<String>(
    initialValue: value,
    validator: (value) => value == null ? 'Selecciona un rol activo' : null,
    builder: (field) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Rol *', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text(
          'Selecciona el rol que tendrá el usuario',
          style: TextStyle(color: AppColors.colorTextoSecundario),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, box) {
            final columns = box.maxWidth >= 520 ? 2 : 1;
            final width = (box.maxWidth - (columns - 1) * 16) / columns;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final role in roles)
                  SizedBox(
                    width: width,
                    child: Semantics(
                      selected: value == role.id,
                      child: AppCard(
                        padding: EdgeInsets.zero,
                        color: value == role.id
                            ? AppColors.colorPrimarioContainer
                            : AppColors.colorFondo,
                        borderColor: value == role.id
                            ? AppColors.colorPrimario
                            : AppColors.colorOutlineVariant,
                        child: InkWell(
                          onTap: enabled
                              ? () {
                                  field.didChange(role.id);
                                  onChanged(role.id);
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.admin_panel_settings_outlined,
                                      color: AppColors.colorPrimario,
                                      size: 28,
                                    ),
                                    const Spacer(),
                                    Icon(
                                      value == role.id
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: value == role.id
                                          ? AppColors.colorPrimario
                                          : AppColors.colorOutlineVariant,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  role.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (role.description?.isNotEmpty == true) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    role.description!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.colorTextoSecundario,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        if (field.hasError) ...[
          const SizedBox(height: 8),
          Text(
            field.errorText!,
            style: const TextStyle(color: AppColors.error),
          ),
        ],
      ],
    ),
  );
}
