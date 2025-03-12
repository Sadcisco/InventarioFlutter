import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipo.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  // Método para iniciar sesión
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'usuario': data};
    } else {
      return {'success': false};
    }
  }

  // Método para obtener todos los equipos
  static Future<List<Map<String, dynamic>>> getEquipos() async {
    final response = await http.get(Uri.parse('$baseUrl/equipos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al obtener los equipos');
    }
  }

  // Método para eliminar un equipo
  static Future<void> eliminarEquipo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/equipos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el equipo');
    }
  }

  // Método para editar un equipo
static Future<void> editarEquipo(int id, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('$baseUrl/equipos/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al editar el equipo');
  }
}
  // Método para agregar un equipo
  static Future<void> agregarEquipo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/equipos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al agregar el equipo');
    }
  }

  // Método adicional para actualizar un equipo (soluciona el error en edit_equipo_screen.dart)
  static Future<void> updateEquipo(Equipo equipo) async {
    await editarEquipo(equipo.id, equipo.toJson());
  }
}
