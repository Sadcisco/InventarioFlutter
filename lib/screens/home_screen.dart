import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipo.dart';
import '../services/api_service.dart';
import 'add_equipo_screen.dart';
import 'login_screen.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Equipo> equipos = [];
  List<Equipo> equiposFiltrados = [];
  Equipo? equipoSeleccionado;

  TextEditingController filtroController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkSession();
    fetchEquipos();
  }

  void checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> fetchEquipos() async {
    try {
      final data = await ApiService.getEquipos();
      setState(() {
        equipos = data.map<Equipo>((json) => Equipo.fromJson(json)).toList();
        equiposFiltrados = List.from(equipos);
      });
    } catch (e) {
      print('Error al cargar equipos: $e');
    }
  }

  void filtrarBusqueda(String texto) {
    setState(() {
      equiposFiltrados = equipos.where((equipo) {
        final lowerText = texto.toLowerCase();
        return equipo.tipo.toLowerCase().contains(lowerText) ||
            equipo.modelo.toLowerCase().contains(lowerText) ||
            equipo.serial.toLowerCase().contains(lowerText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Buscar con ancho reducido al 40%
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: filtroController,
                    onChanged: filtrarBusqueda,
                    decoration: InputDecoration(
                      labelText: 'Buscar...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para abrir el filtro (ajústalo según lo necesites)
                  },
                  child: Text("Filtros"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 219, 168, 228),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.green.shade400),
                        columns: const [
                          DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Modelo', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Serial', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Fecha Registro', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: equiposFiltrados.map((equipo) {
                          return DataRow(
                            selected: equipoSeleccionado == equipo,
                            onSelectChanged: (selected) {
                              setState(() {
                                equipoSeleccionado = equipo;
                              });
                            },
                            cells: [
                              DataCell(Text(equipo.id.toString())),
                              DataCell(Text(equipo.tipo)),
                              DataCell(Text(equipo.modelo)),
                              DataCell(Text(equipo.serial)),
                              DataCell(Text(equipo.fechaRegistro ?? 'Sin registro')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: equipoSeleccionado == null
                          ? Center(child: Text('Selecciona un equipo para ver detalles', style: TextStyle(fontSize: 16)))
                          : Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DETALLE DEL EQUIPO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    Divider(),
                                    SizedBox(height: 8),
                                    Text('Tipo: ${equipoSeleccionado!.tipo}', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 8),
                                    Text('Modelo: ${equipoSeleccionado!.modelo}', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 8),
                                    Text('Serial: ${equipoSeleccionado!.serial}', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 8),
                                    Text('Fecha Registro: ${equipoSeleccionado!.fechaRegistro}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEquipoScreen()),
          );
          fetchEquipos();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}