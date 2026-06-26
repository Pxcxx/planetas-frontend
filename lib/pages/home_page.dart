import 'package:flutter/material.dart';

import '../models/planeta.dart';
import '../services/planeta_service.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/planeta_table.dart';
import 'formulario_page.dart';

/// Pantalla principal de la aplicación.
///
/// Al iniciar consulta automáticamente el backend y muestra el listado
/// de planetas en una tabla. Permite crear, editar y eliminar planetas.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlanetaService _planetaService = PlanetaService();

  List<Planeta> _planetas = [];
  bool _cargando = true;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarPlanetas();
  }

  Future<void> _cargarPlanetas() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final planetas = await _planetaService.listarPlanetas();
      setState(() {
        _planetas = planetas;
        _cargando = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _mensajeError = e.message;
        _cargando = false;
      });
      _mostrarSnackBar(e.message, esError: true);
    }
  }

  Future<void> _navegarAFormulario({Planeta? planeta}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => FormularioPage(planeta: planeta),
      ),
    );

    if (guardado == true) {
      _mostrarSnackBar(
        planeta == null
            ? 'Planeta creado correctamente.'
            : 'Planeta actualizado correctamente.',
      );
      await _cargarPlanetas();
    }
  }

  Future<void> _eliminarPlaneta(Planeta planeta) async {
    final confirmar = await mostrarDialogoConfirmarEliminacion(
      context,
      nombrePlaneta: planeta.nombre,
    );

    if (confirmar != true || planeta.id == null) return;

    try {
      await _planetaService.eliminarPlaneta(planeta.id!);
      _mostrarSnackBar('Planeta eliminado correctamente.');
      await _cargarPlanetas();
    } on ApiException catch (e) {
      _mostrarSnackBar(e.message, esError: true);
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Planetas'),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            icon: const Icon(Icons.refresh),
            onPressed: _cargando ? null : _cargarPlanetas,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navegarAFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Planeta'),
      ),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mensajeError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(_mensajeError!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cargarPlanetas,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_planetas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.public_off, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('No existen planetas registrados.'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarPlanetas,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: PlanetaTable(
            planetas: _planetas,
            onEdit: (planeta) => _navegarAFormulario(planeta: planeta),
            onDelete: _eliminarPlaneta,
          ),
        ),
      ),
    );
  }
}
