
/// Desarrollo:
///   static const String baseUrl = "http://localhost:8080/api";
///
/// Producción:
///   static const String baseUrl = "https://mi-backend.onrender.com/api";
class ApiConstants {
  ApiConstants._();

  /// URL base del backend Spring Boot.
  static const String baseUrl = "http://localhost:8080/api";

  /// Endpoint del recurso "planetas".
  static const String planetasEndpoint = "$baseUrl/planetas";
}
