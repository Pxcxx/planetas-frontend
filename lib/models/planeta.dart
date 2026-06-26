/// Modelo que representa un Planeta proveniente del backend.
class Planeta {
  final int? id;
  final String nombre;
  final double diametro;
  final double masa;
  final double distanciaSol;
  final int habitantes;
  final bool tieneLunas;

  Planeta({
    this.id,
    required this.nombre,
    required this.diametro,
    required this.masa,
    required this.distanciaSol,
    required this.habitantes,
    required this.tieneLunas,
  });

  /// Crea una instancia de [Planeta] a partir de un mapa JSON.
  factory Planeta.fromJson(Map<String, dynamic> json) {
    return Planeta(
      id: json['id'] as int?,
      nombre: json['nombre']?.toString() ?? '',
      diametro: _toDouble(json['diametro']),
      masa: _toDouble(json['masa']),
      distanciaSol: _toDouble(json['distanciaSol']),
      habitantes: _toInt(json['habitantes']),
      tieneLunas: json['tieneLunas'] as bool? ?? false,
    );
  }

  /// Convierte la instancia actual en un mapa JSON para enviar al backend.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'diametro': diametro,
      'masa': masa,
      'distanciaSol': distanciaSol,
      'habitantes': habitantes,
      'tieneLunas': tieneLunas,
    };
  }

  /// Devuelve una copia del planeta con los campos indicados sobrescritos.
  Planeta copyWith({
    int? id,
    String? nombre,
    double? diametro,
    double? masa,
    double? distanciaSol,
    int? habitantes,
    bool? tieneLunas,
  }) {
    return Planeta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      diametro: diametro ?? this.diametro,
      masa: masa ?? this.masa,
      distanciaSol: distanciaSol ?? this.distanciaSol,
      habitantes: habitantes ?? this.habitantes,
      tieneLunas: tieneLunas ?? this.tieneLunas,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
