import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipo.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Equipo> equipos = [];
  List<Equipo> equiposFiltrados = [];
  Equipo? equipoSeleccionado;

  final TextEditingController filtroController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkSession();
    fetchEquipos();
  }

  // Verificar si el usuario está logueado
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

  // Cerrar sesión
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Obtener la lista de equipos desde la API
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

  // Filtrar la lista de equipos
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

  // Mostrar diálogo para agregar un nuevo equipo
  void mostrarAgregarEquipoDialog() {
    final _formKey = GlobalKey<FormState>();
    final tipoController = TextEditingController();
    final modeloController = TextEditingController();
    final serialController = TextEditingController();
    final sucursalController = TextEditingController();
    final usuarioController = TextEditingController();
    final fechaRegistroController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Equipo"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: tipoController, decoration: const InputDecoration(labelText: 'Tipo')),
                  TextFormField(controller: modeloController, decoration: const InputDecoration(labelText: 'Modelo')),
                  TextFormField(controller: serialController, decoration: const InputDecoration(labelText: 'Serial')),
                  TextFormField(controller: sucursalController, decoration: const InputDecoration(labelText: 'Sucursal ID')),
                  TextFormField(controller: usuarioController, decoration: const InputDecoration(labelText: 'Usuario ID')),
                  TextFormField(controller: fechaRegistroController, decoration: const InputDecoration(labelText: 'Fecha de Registro')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Equipo nuevoEquipo = Equipo(
                    id: 0,
                    tipo: tipoController.text,
                    modelo: modeloController.text,
                    serial: serialController.text,
                    sucursalId: int.parse(sucursalController.text),
                    usuarioId: int.parse(usuarioController.text),
                    fechaRegistro: fechaRegistroController.text,
                  );

                  await ApiService.agregarEquipo(nuevoEquipo.toJson());
                  fetchEquipos();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda y filtros
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.6,
                  child: TextField(
                    controller: filtroController,
                    onChanged: filtrarBusqueda,
                    decoration: InputDecoration(
                      labelText: 'Buscar...',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {}, // Filtro aún sin implementar
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Filtros"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tabla de equipos y detalles
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabla de equipos
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.green.shade400),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Modelo')),
                          DataColumn(label: Text('Serial')),
                          DataColumn(label: Text('Fecha Registro')),
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
                              DataCell(Text(equipo.fechaRegistro)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Detalles del equipo seleccionado
                  if (equipoSeleccionado != null)
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DETALLE DEL EQUIPO',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Divider(),
                              Text('Tipo: ${equipoSeleccionado!.tipo}'),
                              Text('Modelo: ${equipoSeleccionado!.modelo}'),
                              Text('Serial: ${equipoSeleccionado!.serial}'),
                              Text('Fecha Registro: ${equipoSeleccionado!.fechaRegistro}'),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Editar"),
                                    onPressed: () => Navigator.pushNamed(context, '/edit_equipo', arguments: equipoSeleccionado),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.delete),
                                    label: const Text("Eliminar"),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () async {
                                      await ApiService.eliminarEquipo(equipoSeleccionado!.id);
                                      fetchEquipos();
                                      setState(() => equipoSeleccionado = null);
                                    },
                                  ),
                                ],
                              ),
                            ],
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
        onPressed: mostrarAgregarEquipoDialog,
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}