import 'package:flutter/material.dart';

/// Muestra un [AlertDialog] de confirmación de eliminación.
///
/// Devuelve `true` si el usuario confirma la eliminación, `false` o `null`
/// en caso contrario.
Future<bool?> mostrarDialogoConfirmarEliminacion(
  BuildContext context, {
  required String nombrePlaneta,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar el planeta "$nombrePlaneta"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}
