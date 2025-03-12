import 'package:flutter/material.dart';
import '../models/equipo.dart';
import '../services/api_service.dart';

void mostrarAgregarEquipoDialog(BuildContext context, Function onEquipoAgregado) {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de los campos
  final tipoController = TextEditingController();
  final modeloController = TextEditingController();
  final serialController = TextEditingController();
  final sucursalController = TextEditingController();
  final usuarioController = TextEditingController();
  final fechaRegistroController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Agregar Equipo'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tipoController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el tipo' : null,
                ),
                TextFormField(
                  controller: modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el modelo' : null,
                ),
                TextFormField(
                  controller: serialController,
                  decoration: const InputDecoration(labelText: 'Serial'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el serial' : null,
                ),
                TextFormField(
                  controller: sucursalController,
                  decoration: const InputDecoration(labelText: 'Sucursal ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese el Sucursal ID' : null,
                ),
                TextFormField(
                  controller: usuarioController,
                  decoration: const InputDecoration(labelText: 'Usuario ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese el Usuario ID' : null,
                ),
                TextFormField(
                  controller: fechaRegistroController,
                  decoration: const InputDecoration(labelText: 'Fecha de Registro'),
                  validator: (value) => value!.isEmpty ? 'Ingrese la fecha de registro' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Limpia los controladores antes de cerrar el diálogo
              tipoController.dispose();
              modeloController.dispose();
              serialController.dispose();
              sucursalController.dispose();
              usuarioController.dispose();
              fechaRegistroController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  Equipo nuevoEquipo = Equipo(
                    id: 0, // ID se genera automáticamente en la BD
                    tipo: tipoController.text,
                    modelo: modeloController.text,
                    serial: serialController.text,
                    sucursalId: int.tryParse(sucursalController.text) ?? 0,
                    usuarioId: int.tryParse(usuarioController.text) ?? 0,
                    fechaRegistro: fechaRegistroController.text,
                  );

                  await ApiService.agregarEquipo(nuevoEquipo.toJson());

                  // Notifica que se agregó un equipo y actualiza la pantalla
                  onEquipoAgregado();

                  // Limpia los controladores antes de cerrar el diálogo
                  tipoController.dispose();
                  modeloController.dispose();
                  serialController.dispose();
                  sucursalController.dispose();
                  usuarioController.dispose();
                  fechaRegistroController.dispose();

                  // Cierra el diálogo
                  Navigator.pop(dialogContext);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al agregar equipo: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar Equipo'),
          ),
        ],
      );
    },
  );
}
