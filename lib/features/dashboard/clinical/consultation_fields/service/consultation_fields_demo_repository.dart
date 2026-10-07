import '../model/clinical_field_record.dart';
import '../../shared/service/clinical_repository.dart';

final consultationFieldsRepository =
    DemoClinicalRepository<ClinicalFieldRecord>([
      ClinicalFieldRecord.fromJson({
        "id": "demo-1",
        "active": true,
        "label": "Motivo de consulta",
        "field_type": "textarea",
        "required": true,
        "config": {"placeholder": "Describe el motivo de la visita"},
      }),
      ClinicalFieldRecord.fromJson({
        "id": "demo-2",
        "active": false,
        "label": "Observaciones",
        "field_type": "textarea",
        "required": false,
        "config": {"placeholder": "Anota las observaciones de la consulta"},
      }),
    ]);
