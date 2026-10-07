import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/features/dashboard/clinical/patients/model/patient.dart';
import 'package:medimaya_app/features/dashboard/clinical/specialties/model/specialty.dart';
import 'package:medimaya_app/features/dashboard/clinical/document_types/model/document_type.dart';
import 'package:medimaya_app/features/dashboard/clinical/consultations/model/consultation.dart';
import 'package:medimaya_app/features/dashboard/clinical/consultation_forms/model/consultation_form.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/model/clinical_record.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/model/clinical_section.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/service/clinical_repository.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/store/clinical_form_notifier.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/widget/clinical_data_view.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/widget/clinical_fields.dart';

class RetryingRepository implements ClinicalRepository<ClinicalRecord> {
  int attempts = 0;
  @override
  Future<List<ClinicalRecord>> list() async {
    if (++attempts == 1) throw StateError('unavailable');
    return [
      Specialty.fromJson({
        'id': 'specialty-42',
        'active': true,
        'name': 'General',
      }),
    ];
  }
}

void main() {
  test('models serialize technical keys, lists, IDs and booleans', () {
    final fixtures =
        <(Map<String, Object?>, ClinicalRecord Function(Map<String, Object?>))>[
          (
            {
              'id': 'p-9',
              'active': false,
              'first_name': 'Ana',
              'last_name': 'Pérez',
              'birth_date': '2000-01-01',
              'sex': 'Femenino',
              'phone': '123',
              'email': 'a@example.com',
              'patient_code': 'PAC-9',
            },
            Patient.fromJson,
          ),
          (
            {
              'id': 's-3',
              'active': true,
              'name': 'General',
              'description': 'Atención',
            },
            Specialty.fromJson,
          ),
          (
            {
              'id': 'd-4',
              'active': true,
              'name': 'Laboratorio',
              'description': '',
              'allowed_extensions': ['pdf', 'png'],
              'max_size_mb': 15,
            },
            DocumentType.fromJson,
          ),
          (
            {
              'id': 'c-2',
              'active': true,
              'patient_id': 'p-9',
              'patient_name': 'Ana Pérez',
              'form_id': 'f-8',
              'form_name': 'General',
              'consulted_at': '2026-10-07',
              'status': 'draft',
              'notes': '',
            },
            Consultation.fromJson,
          ),
          (
            {
              'id': 'f-8',
              'active': true,
              'name': 'General',
              'specialty_id': 's-3',
              'specialty_name': 'General',
              'description': '',
              'status': 'draft',
            },
            ConsultationForm.fromJson,
          ),
        ];
    for (final (json, parse) in fixtures) {
      final record = parse(json);
      expect(record.toJson(), json);
      expect(record.toValues()['id'], json['id']);
      expect(
        record.toValues()['active'],
        json['active'] == true ? 'Activo' : 'Inactivo',
      );
    }
    expect(
      () => DocumentType.fromJson({
        'id': 'broken',
        'active': true,
        'allowed_extensions': 'pdf',
        'max_size_mb': 1,
      }),
      throwsA(isA<TypeError>()),
    );
  });

  testWidgets(
    'repository error can retry and resolve an ID unrelated to row position',
    (tester) async {
      final section = ClinicalSection(
        slug: 'specialties',
        title: 'Especialidades',
        singular: 'especialidad',
        description: '',
        fields: [],
        tableFields: [],
        repository: RetryingRepository(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClinicalDataView(
              sections: [section],
              builder: (_) => Text(section.records.single.id),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('No se pudo cargar la información de Clínica.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('specialty-42'), findsOneWidget);
      expect(section.indexOfId('specialty-42'), 0);
      expect(section.indexOfId('demo-1'), -1);
    },
  );

  testWidgets(
    'text fields capture technical keys independent of Spanish labels',
    (tester) async {
      final notifier = ClinicalFormNotifier({});
      addTearDown(notifier.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClinicalFields(
              fields: const [
                ClinicalField('Nombre visible', key: 'first_name'),
              ],
              values: const {},
              readOnly: false,
              notifier: notifier,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField), 'Ana');
      expect(notifier.values, {'first_name': 'Ana'});
    },
  );
}
