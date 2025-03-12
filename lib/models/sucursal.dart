class Sucursal {
  final int id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String fechaRegistro;

  Sucursal({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.fechaRegistro,
  });

  // Método para convertir un JSON en un objeto Sucursal
  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      fechaRegistro: json['fecha_registro'],
    );
  }

  // Método para convertir un objeto Sucursal a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'fecha_registro': fechaRegistro,
    };
  }
}