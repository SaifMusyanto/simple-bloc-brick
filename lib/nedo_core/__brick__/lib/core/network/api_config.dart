class ApiConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, String> headers;

  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.headers = const <String, String>{'Content-Type': 'application/json'},
  });

  factory ApiConfig.defaultConfig() {
    return const ApiConfig(
      baseUrl: 'https://api.example.com', // TODO: Replace with your actual base URL
      headers: <String, String>{'Content-Type': 'application/json'},
    );
  }
}
