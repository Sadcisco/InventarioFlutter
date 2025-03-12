import 'package:flutter/material.dart';
import '../models/equipo.dart';
import '../services/api_service.dart';

class EditEquipoScreen extends StatefulWidget {
  final Equipo equipo;

  const EditEquipoScreen({Key? key, required this.equipo}) : super(key: key);

  @override
  _EditEquipoScreenState createState() => _EditEquipoScreenState();
}

class _EditEquipoScreenState extends State<EditEquipoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tipoController;
  late TextEditingController modeloController;
  late TextEditingController serialController;
  late TextEditingController sucursalController;
  late TextEditingController usuarioController;
  late TextEditingController fechaRegistroController;

  @override
  void initState() {
    super.initState();
    tipoController = TextEditingController(text: widget.equipo.tipo);
    modeloController = TextEditingController(text: widget.equipo.modelo);
    serialController = TextEditingController(text: widget.equipo.serial);
    sucursalController = TextEditingController(text: widget.equipo.sucursalId.toString());
    usuarioController = TextEditingController(text: widget.equipo.usuarioId.toString());
    fechaRegistroController = TextEditingController(text: widget.equipo.fechaRegistro);
  }

  @override
  void dispose() {
    tipoController.dispose();
    modeloController.dispose();
    serialController.dispose();
    sucursalController.dispose();
    usuarioController.dispose();
    fechaRegistroController.dispose();
    super.dispose();
  }

  void guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      Equipo equipoActualizado = Equipo(
        id: widget.equipo.id,
        tipo: tipoController.text,
        modelo: modeloController.text,
        serial: serialController.text,
        sucursalId: int.tryParse(sucursalController.text) ?? 0,
        usuarioId: int.tryParse(usuarioController.text) ?? 0,
        fechaRegistro: fechaRegistroController.text,
      );

      try {
        await ApiService.editarEquipo(equipoActualizado.id, equipoActualizado.toJson());
        Navigator.pop(context, equipoActualizado); // Devuelve el equipo actualizado
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Equipo'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) => value!.isEmpty ? 'Ingrese el tipo' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) => value!.isEmpty ? 'Ingrese el modelo' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: serialController,
                decoration: const InputDecoration(labelText: 'Serial'),
                validator: (value) => value!.isEmpty ? 'Ingrese el serial' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: sucursalController,
                decoration: const InputDecoration(labelText: 'Sucursal ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese el ID de la sucursal' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: usuarioController,
                decoration: const InputDecoration(labelText: 'Usuario ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese el ID del usuario' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: fechaRegistroController,
                decoration: const InputDecoration(labelText: 'Fecha de Registro'),
                validator: (value) => value!.isEmpty ? 'Ingrese la fecha de registro' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: guardarCambios,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
