import '../../shared/store/clinical_form_notifier.dart';

import 'package:flutter/material.dart';

import '../../patients/model/patients_section.dart';
import '../../shared/widget/clinical_fields.dart';
import 'patient_qr_preview.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/filter_tabs.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class ConsultationPatientField extends StatefulWidget {
  const ConsultationPatientField({
    super.key,
    this.initialPatient,
    this.onChanged,
  });
  final String? initialPatient;
  final ValueChanged<Map<String, String>>? onChanged;

  @override
  State<ConsultationPatientField> createState() =>
      _ConsultationPatientFieldState();
}

class _ConsultationPatientFieldState extends State<ConsultationPatientField> {
  final _newPatientForm = ClinicalFormNotifier({});
  final _id = TextEditingController();
  bool _newPatient = false;
  Map<String, String>? _patient;
  String? _error;

  @override
  void initState() {
    super.initState();
    _newPatientForm.addListener(_notifyNewPatient);
    for (final patient in patientsSection.rows) {
      if ('${patient['first_name']} ${patient['last_name']}' ==
          widget.initialPatient) {
        _patient = patient;
        _id.text = patient['patient_code'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _newPatientForm.dispose();
    _id.dispose();
    super.dispose();
  }

  void _notifyNewPatient() => widget.onChanged?.call(_newPatientForm.values);

  void _assign() {
    final matches = patientsSection.rows.where(
      (patient) => patient['patient_code'] == _id.text.trim().toUpperCase(),
    );
    setState(() {
      _patient = matches.firstOrNull;
      widget.onChanged?.call(_patient ?? {});
      _error = _patient == null
          ? 'No existe un paciente de ejemplo con ese ID.'
          : null;
    });
  }

  Future<void> _scan() async {
    final id = await showDialog<String>(
      context: context,
      builder: (context) => const PatientQrPreview(),
    );
    if (!mounted || id == null) return;
    _id.text = id;
    _assign();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Paciente de la consulta',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      const Text(
        'Selecciona cómo identificar al paciente antes de completar la consulta.',
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.colorTextoSecundario,
        ),
      ),
      const SizedBox(height: 16),
      if (hasPermission('patients:create'))
        AppFilterTabs(
          filter: _newPatient ? 'new' : 'existing',
          options: const [
            FilterOption(value: 'existing', label: 'Paciente existente'),
            FilterOption(value: 'new', label: 'Nuevo paciente'),
          ],
          onChanged: (value) => setState(() {
            _newPatient = value == 'new';
            widget.onChanged?.call(
              _newPatient ? _newPatientForm.values : (_patient ?? {}),
            );
          }),
        ),
      const SizedBox(height: 16),
      if (_newPatient) ...[
        const Text(
          'El paciente se registrará junto con la consulta. '
          'En esta maqueta no se guarda información.',
        ),
        const SizedBox(height: 16),
        ClinicalFields(
          notifier: _newPatientForm,
          fields: patientsSection.fields
              .where((field) => field.key != 'patient_code')
              .toList(),
          values: const {},
          readOnly: false,
        ),
      ] else ...[
        AppInput(
          name: 'ID del paciente',
          controller: _id,
          helperText: 'Ejemplo: PAC-DEMO-001',
          errorText: _error,
          onChanged: (_) => setState(() {
            _patient = null;
            widget.onChanged?.call({});
            _error = null;
          }),
          onFieldSubmitted: (_) => _assign(),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              style: ButtonThemes.primary(),
              onPressed: _assign,
              child: const Text('Asignar por ID'),
            ),
            OutlinedButton.icon(
              style: ButtonThemes.secondary(),
              onPressed: _scan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear QR'),
            ),
          ],
        ),
        if (_patient case final patient?) ...[
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paciente asignado · Ejemplo',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${patient['first_name']} ${patient['last_name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('ID: ${patient['patient_code']}'),
              ],
            ),
          ),
        ],
      ],
    ],
  );
}
