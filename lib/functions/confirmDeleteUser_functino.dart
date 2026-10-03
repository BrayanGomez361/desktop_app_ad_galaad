import 'package:ad_galaad_app/classes/user_class.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/material.dart' as material;

// Diálogo para confirmar la eliminación local
  void confirmarEliminacionUsuarioLocal(BuildContext context, UsuarioApp? user) {
    if(user == null) return;
    showDialog(
      context: context,
      builder: (contextDialog) {
        return ContentDialog (
          title: const Text('Eliminar usuario local'),
          content: Text('¿Estás seguro de que deseas eliminar a "${user.name}" del almacenamiento local?'),
          actions: [
            Button(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(contextDialog),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text('Eliminar',
                style: TextStyle(color: CupertinoColors.white ),
              ),
              onPressed: () async {
                
                await context.read<LocalStorageProvider>().eliminarUsuario(user.id);
                
                
                Navigator.pop(contextDialog);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }