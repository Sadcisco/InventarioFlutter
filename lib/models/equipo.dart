class Equipo {
  final int id;
  final String tipo;
  final String modelo;
  final String serial;
  final String? fechaRegistro;

  Equipo({
    required this.id,
    required this.tipo,
    required this.modelo,
    required this.serial,
    this.fechaRegistro,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      tipo: json['tipo'],
      modelo: json['modelo'],
      serial: json['serial'],
      fechaRegistro: json['fecha_registro'],  // Importante que el nombre coincida con el de la API
    );
  }
}
