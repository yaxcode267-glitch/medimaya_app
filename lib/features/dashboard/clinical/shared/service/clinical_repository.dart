import '../model/clinical_record.dart';

abstract interface class ClinicalRepository<T extends ClinicalRecord> {
  Future<List<T>> list();
}

class DemoClinicalRepository<T extends ClinicalRecord>
    implements ClinicalRepository<T> {
  const DemoClinicalRepository(this.records);
  final List<T> records;
  @override
  Future<List<T>> list() async => List.unmodifiable(records);
}
