class Equipo {
  final int id;
  final String tipo;
  final String modelo;
  final String serial;
  final int sucursalId;
  final int usuarioId;
  final String fechaRegistro;

  // Constructor
  Equipo({
    required this.id,
    required this.tipo,
    required this.modelo,
    required this.serial,
    required this.sucursalId,
    required this.usuarioId,
    required this.fechaRegistro,
  });

  // Método para convertir un mapa JSON a un objeto Equipo
  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      tipo: json['tipo'],
      modelo: json['modelo'],
      serial: json['serial'],
      sucursalId: json['sucursal_id'], // Nuevo campo
      usuarioId: json['usuario_id'],   // Nuevo campo
      fechaRegistro: json['fecha_registro'],
    );
  }

  // Método para convertir un objeto Equipo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'modelo': modelo,
      'serial': serial,
      'sucursal_id': sucursalId, // Nuevo campo
      'usuario_id': usuarioId,   // Nuevo campo
      'fecha_registro': fechaRegistro,
    };
  }
}
