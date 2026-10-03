import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

Future<bool> mostrarDialogoDeConfirmacion({
  required BuildContext context,
  required String titulo,
  required String mensaje,
  String textoConfirmar = 'Confirmar',
  String textoCancelar = 'Cancelar',
}) async {
  final bool? resultado = await showDialog<bool>(
    context: context,
    builder: (contextDialog) {
      return ContentDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          Button(
            child: Text(textoCancelar),
            onPressed: () {
              Navigator.pop(contextDialog, false); // Cierra y retorna false
            },
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red),
            ),
            onPressed: () {
              Navigator.pop(contextDialog, true); // Cierra y retorna true
            },
            child: Text(
              textoConfirmar,
              style: const TextStyle(color: CupertinoColors.white),
            ),
          ),
        ],
      );
    },
  );

  // Si se presiona fuera o se cancela, retornamos false por seguridad
  return resultado ?? false;
}