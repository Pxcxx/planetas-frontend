import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/planeta.dart';
import '../utils/api_constants.dart';

/// Excepción personalizada para errores controlados de la capa de servicios.
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

/// Servicio encargado de consumir el CRUD de planetas del backend Spring Boot.
///
/// Todas las peticiones utilizan [ApiConstants.planetasEndpoint], que a su
/// vez se construye a partir de [ApiConstants.baseUrl]. No se debe repetir
/// la URL del backend en ningún otro lugar del proyecto.
class PlanetaService {
  final http.Client _client;

  PlanetaService({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene la lista completa de planetas registrados en el backend.
  Future<List<Planeta>> listarPlanetas() async {
    final response = await _ejecutarPeticion(
      () => _client.get(Uri.parse(ApiConstants.planetasEndpoint)),
    );

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((json) => Planeta.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene un planeta específico a partir de su [id].
  Future<Planeta> obtenerPlaneta(int id) async {
    final response = await _ejecutarPeticion(
      () => _client.get(Uri.parse('${ApiConstants.planetasEndpoint}/$id')),
    );

    return Planeta.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Crea un nuevo planeta en el backend.
  Future<Planeta> crearPlaneta(Planeta planeta) async {
    final response = await _ejecutarPeticion(
      () => _client.post(
        Uri.parse(ApiConstants.planetasEndpoint),
        headers: _headers,
        body: jsonEncode(planeta.toJson()),
      ),
    );

    return Planeta.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Actualiza un planeta existente identificado por [id].
  Future<Planeta> actualizarPlaneta(int id, Planeta planeta) async {
    final response = await _ejecutarPeticion(
      () => _client.put(
        Uri.parse('${ApiConstants.planetasEndpoint}/$id'),
        headers: _headers,
        body: jsonEncode(planeta.toJson()),
      ),
    );

    return Planeta.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Elimina un planeta identificado por [id].
  Future<void> eliminarPlaneta(int id) async {
    await _ejecutarPeticion(
      () => _client.delete(Uri.parse('${ApiConstants.planetasEndpoint}/$id')),
    );
  }

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json; charset=UTF-8',
      };

  /// Ejecuta una petición HTTP centralizando el manejo de errores de red,
  /// de tiempo de espera y de códigos de estado HTTP no exitosos.
  Future<http.Response> _ejecutarPeticion(
    Future<http.Response> Function() peticion,
  ) async {
    try {
      final response = await peticion().timeout(const Duration(seconds: 15));
      _validarRespuesta(response);
      return response;
    } on SocketException {
      throw ApiException(
        'No hay conexión con el servidor. Verifica que el backend esté disponible.',
      );
    } on HttpException {
      throw ApiException('Ocurrió un error al comunicarse con el servidor.');
    } on FormatException {
      throw ApiException('La respuesta del servidor no tiene un formato válido.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Valida el código de estado HTTP y lanza [ApiException] cuando
  /// corresponde a un error.
  void _validarRespuesta(http.Response response) {
    final codigo = response.statusCode;

    if (codigo >= 200 && codigo < 300) {
      return;
    }

    switch (codigo) {
      case 400:
        throw ApiException('Solicitud inválida. Verifica los datos enviados.');
      case 404:
        throw ApiException('El planeta solicitado no existe.');
      case 500:
        throw ApiException('Error interno del servidor.');
      default:
        throw ApiException('Error del servidor (código $codigo).');
    }
  }
}
