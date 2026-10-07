import 'package:collection/collection.dart';

Map<String, Object?> fieldConfigOverride(
  Map<String, Object?> config,
  Map<String, Object?> defaults,
) => {
  for (final entry in config.entries)
    if (entry.value != null &&
        entry.value != '' &&
        !const DeepCollectionEquality().equals(
          entry.value,
          defaults[entry.key],
        ))
      entry.key: entry.value,
};
