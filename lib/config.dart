/// URL dasar Django REST Framework. Ganti sesuai perangkat dengan --dart-define.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
