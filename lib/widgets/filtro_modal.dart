import 'package:flutter/material.dart';

class FiltroModal extends StatefulWidget {
  final Function(String?, String?) onAplicarFiltro;

  const FiltroModal({super.key, required this.onAplicarFiltro});

  @override
  State<FiltroModal> createState() => _FiltroModalState();
}

class _FiltroModalState extends State<FiltroModal> {
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtros'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tipoController,
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
          TextField(
            controller: modeloController,
            decoration: const InputDecoration(labelText: 'Modelo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAplicarFiltro(tipoController.text, modeloController.text);
            Navigator.pop(context);
          },
          child: const Text('Aplicar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
