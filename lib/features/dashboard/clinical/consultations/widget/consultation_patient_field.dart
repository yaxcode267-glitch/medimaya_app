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
  const ConsultationPatientField({super.key, this.initialPatient});
  final String? initialPatient;

  @override
  State<ConsultationPatientField> createState() =>
      _ConsultationPatientFieldState();
}

class _ConsultationPatientFieldState extends State<ConsultationPatientField> {
  final _id = TextEditingController();
  bool _newPatient = false;
  Map<String, String>? _patient;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final patient in patientsSection.examples) {
      if ('${patient['Nombres']} ${patient['Apellidos']}' ==
          widget.initialPatient) {
        _patient = patient;
        _id.text = patient['ID'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  void _assign() {
    final matches = patientsSection.examples.where(
      (patient) => patient['ID'] == _id.text.trim().toUpperCase(),
    );
    setState(() {
      _patient = matches.firstOrNull;
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
          onChanged: (value) => setState(() => _newPatient = value == 'new'),
        ),
      const SizedBox(height: 16),
      if (_newPatient) ...[
        const Text(
          'El paciente se registrará junto con la consulta. '
          'En esta maqueta no se guarda información.',
        ),
        const SizedBox(height: 16),
        ClinicalFields(
          fields: patientsSection.fields
              .where((field) => field.label != 'ID')
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
                  '${patient['Nombres']} ${patient['Apellidos']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('ID: ${patient['ID']}'),
              ],
            ),
          ),
        ],
      ],
    ],
  );
}
