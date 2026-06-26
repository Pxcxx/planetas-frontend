import 'package:flutter/material.dart';

import '../models/planeta.dart';
import '../services/planeta_service.dart';

/// Pantalla de formulario utilizada tanto para crear un nuevo planeta
/// como para editar uno existente.
///
/// Si [planeta] es `null`, el formulario opera en modo "crear".
/// Si [planeta] tiene un valor, el formulario opera en modo "editar"
/// y precarga los datos correspondientes.
class FormularioPage extends StatefulWidget {
  final Planeta? planeta;

  const FormularioPage({super.key, this.planeta});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final PlanetaService _planetaService = PlanetaService();

  late final TextEditingController _nombreController;
  late final TextEditingController _diametroController;
  late final TextEditingController _masaController;
  late final TextEditingController _distanciaSolController;
  late final TextEditingController _habitantesController;

  bool _tieneLunas = false;
  bool _guardando = false;

  bool get _esEdicion => widget.planeta != null;

  @override
  void initState() {
    super.initState();
    final planeta = widget.planeta;

    _nombreController = TextEditingController(text: planeta?.nombre ?? '');
    _diametroController = TextEditingController(
      text: planeta != null ? planeta.diametro.toString() : '',
    );
    _masaController = TextEditingController(
      text: planeta != null ? planeta.masa.toString() : '',
    );
    _distanciaSolController = TextEditingController(
      text: planeta != null ? planeta.distanciaSol.toString() : '',
    );
    _habitantesController = TextEditingController(
      text: planeta != null ? planeta.habitantes.toString() : '',
    );
    _tieneLunas = planeta?.tieneLunas ?? false;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _diametroController.dispose();
    _masaController.dispose();
    _distanciaSolController.dispose();
    _habitantesController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final planeta = Planeta(
      id: widget.planeta?.id,
      nombre: _nombreController.text.trim(),
      diametro: double.parse(_diametroController.text.trim()),
      masa: double.parse(_masaController.text.trim()),
      distanciaSol: double.parse(_distanciaSolController.text.trim()),
      habitantes: int.parse(_habitantesController.text.trim()),
      tieneLunas: _tieneLunas,
    );

    try {
      if (_esEdicion) {
        await _planetaService.actualizarPlaneta(widget.planeta!.id!, planeta);
      } else {
        await _planetaService.crearPlaneta(planeta);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  String? _validarObligatorio(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$campo es obligatorio.';
    }
    return null;
  }

  String? _validarNumeroNoNegativo(String? value, {String campo = 'El valor'}) {
    final obligatorio = _validarObligatorio(value, campo: campo);
    if (obligatorio != null) return obligatorio;

    final numero = double.tryParse(value!.trim());
    if (numero == null) {
      return '$campo debe ser un número válido.';
    }
    if (numero < 0) {
      return '$campo no puede ser negativo.';
    }
    return null;
  }

  String? _validarEnteroNoNegativo(String? value, {String campo = 'El valor'}) {
    final obligatorio = _validarObligatorio(value, campo: campo);
    if (obligatorio != null) return obligatorio;

    final numero = int.tryParse(value!.trim());
    if (numero == null) {
      return '$campo debe ser un número entero válido.';
    }
    if (numero < 0) {
      return '$campo no puede ser negativo.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Planeta' : 'Agregar Planeta'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.public),
                    ),
                    validator: (value) =>
                        _validarObligatorio(value, campo: 'El nombre'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _diametroController,
                    decoration: const InputDecoration(
                      labelText: 'Diámetro (km)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.straighten),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        _validarNumeroNoNegativo(value, campo: 'El diámetro'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _masaController,
                    decoration: const InputDecoration(
                      labelText: 'Masa (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        _validarNumeroNoNegativo(value, campo: 'La masa'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _distanciaSolController,
                    decoration: const InputDecoration(
                      labelText: 'Distancia al Sol (km)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wb_sunny),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) => _validarNumeroNoNegativo(
                      value,
                      campo: 'La distancia al Sol',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _habitantesController,
                    decoration: const InputDecoration(
                      labelText: 'Habitantes',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validarEnteroNoNegativo(value, campo: 'Los habitantes'),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('¿Tiene lunas?'),
                    value: _tieneLunas,
                    onChanged: (value) {
                      setState(() => _tieneLunas = value ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _guardando ? null : _guardar,
                    icon: _guardando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_esEdicion ? 'Actualizar' : 'Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
