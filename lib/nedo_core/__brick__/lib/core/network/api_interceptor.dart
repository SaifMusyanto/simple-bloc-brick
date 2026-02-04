import 'package:dio/dio.dart';
import '../services/secure_storage/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;

  ApiInterceptor(this._secureStorageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Inject token if available
    final token = _secureStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Check if there are other specific headers to add

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific errors like 401 Unauthorized here if needed
    // For now, we propagate the error
    // check if err.response?.statusCode == 401 -> maybe trigger logout or refresh token
    
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // handle global response processing here
    super.onResponse(response, handler);
  }
}
