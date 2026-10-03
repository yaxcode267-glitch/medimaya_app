class StorageKey {
  static const access = 'medinest_access';
  static const refresh = 'medinest_refresh';
  static const profile = 'medinest_profile';

  /// Guard con el que se abrió la sesión. La API emite el mismo par de tokens
  /// para el personal y para el portal de paciente, así que el cliente guarda
  /// con cuál de los dos autenticó para saber a qué área pertenece.
  static const session = 'medinest_session';
}
