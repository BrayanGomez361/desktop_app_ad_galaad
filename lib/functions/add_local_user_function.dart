import 'package:ad_galaad_app/classes/user_class.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:provider/provider.dart';

/// Utilidad: 
/// Diálogo sencillo para crear un usuario rápidamente
void mostrarDialogoNuevoUsuario(BuildContext context ) {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (contextDialog) {
      return ContentDialog(
        title: const Text('Agregar nuevo usuario local'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBox(
              controller: nameController,
              placeholder: 'Nombre completo',
            ),
            const SizedBox(height: 12),
            TextBox(
              controller: emailController,
              placeholder: 'Correo electrónico',
            ),
            const SizedBox(height: 12),
          ],
        ),
        actions: [
          Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(contextDialog),
          ),
          FilledButton(
            child: const Text('Guardar'),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<LocalStorageProvider>().agregarUsuario(
                      UsuarioApp(
                        name: nameController.text,
                        email: emailController.text,
                        //rol: rolSeleccionado,
                        createdAt: DateTime.now(),
                      ),
                    );
                Navigator.pop(contextDialog);
              }
            },
          ),
        ],
      );
    },
  );
}