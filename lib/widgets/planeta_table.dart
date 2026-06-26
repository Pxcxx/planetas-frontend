import 'package:flutter/material.dart';

import '../models/planeta.dart';

/// Tabla que muestra el listado de planetas junto con las acciones
/// de editar y eliminar para cada fila.
class PlanetaTable extends StatelessWidget {
  final List<Planeta> planetas;
  final void Function(Planeta planeta) onEdit;
  final void Function(Planeta planeta) onDelete;

  const PlanetaTable({
    super.key,
    required this.planetas,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.primaryContainer,
          ),
          columns: const [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Diámetro (km)'), numeric: true),
            DataColumn(label: Text('Masa (kg)'), numeric: true),
            DataColumn(label: Text('Distancia al Sol (km)'), numeric: true),
            DataColumn(label: Text('Habitantes'), numeric: true),
            DataColumn(label: Text('¿Tiene lunas?')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: planetas.map((planeta) => _buildRow(context, planeta)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Planeta planeta) {
    return DataRow(
      cells: [
        DataCell(Text(planeta.nombre)),
        DataCell(Text(planeta.diametro.toStringAsFixed(2))),
        DataCell(Text(planeta.masa.toStringAsFixed(2))),
        DataCell(Text(planeta.distanciaSol.toStringAsFixed(2))),
        DataCell(Text(planeta.habitantes.toString())),
        DataCell(
          Icon(
            planeta.tieneLunas ? Icons.check_circle : Icons.cancel,
            color: planeta.tieneLunas ? Colors.green : Colors.redAccent,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(planeta),
              ),
              IconButton(
                tooltip: 'Eliminar',
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(planeta),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
