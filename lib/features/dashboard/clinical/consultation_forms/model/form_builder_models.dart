class ConsultationFieldDefinition {
  const ConsultationFieldDefinition({
    required this.id,
    required this.label,
    required this.fieldType,
    this.required = false,
    this.config = const {},
  });
  final String id;
  final String label;
  final String fieldType;
  final bool required;
  final Map<String, Object?> config;
}

class ConsultationFormElement {
  ConsultationFormElement({
    required this.id,
    required this.type,
    this.name,
    this.field,
    this.parentId,
    this.requiredOverride,
    this.documentTypeId,
    this.documentType,
    Map<String, Object?>? config,
  }) : config = config ?? {};
  final String id;
  final String type;
  final String? name;
  final ConsultationFieldDefinition? field;
  final String? parentId;
  final bool? requiredOverride;
  final String? documentTypeId;
  final Map<String, String>? documentType;
  final Map<String, Object?> config;
  String get label => name ?? field?.label ?? '';
  bool get isRequired => requiredOverride ?? field?.required ?? false;
  Map<String, Object?> get effectiveConfig => {...?field?.config, ...config};
}

const consultationFieldTypes = {
  'text': 'Texto',
  'textarea': 'Texto largo',
  'number': 'Número',
  'date': 'Fecha',
  'select': 'Selección',
  'checkbox': 'Casilla',
  'radio': 'Opción única',
  'document': 'Documento',
};

const formFieldExamples = [
  ConsultationFieldDefinition(
    id: 'field-motive',
    label: 'Motivo de consulta',
    fieldType: 'textarea',
    required: true,
  ),
];
