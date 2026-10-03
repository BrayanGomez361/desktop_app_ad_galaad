

import 'package:ad_galaad_app/classes/privilege_class.dart';

import 'package:fluent_ui/fluent_ui.dart';


Future<Privilege?> mostrarFormEditarPrivilegio(BuildContext context, Privilege privilegio) async {

  final typeController = TextEditingController( text: privilegio.type);
  final userController = TextEditingController( text: privilegio.userId);
  final guidelinesController = TextEditingController(text: privilegio.guidelines);

  return await showDialog<Privilege>(
    context: context, 
    builder: (contextEditPrivilege) {

      return ContentDialog(
        title: Text('Editar información del privilegio'),
        content: Column(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBox(
              placeholder: 'Tipo de privilegio',
              controller: typeController,
            ),

            TextBox(
              placeholder: 'Persona encargada',
              controller: userController,
            ),

            TextBox(
              placeholder: 'Indicaciones',
              controller: guidelinesController,
              
            ),

          ],
        ),
        actions: [
          Button(child: Text('Cancelar'), onPressed: (){
            Navigator.of(contextEditPrivilege).pop(null);
          }),
          FilledButton(child: Text('Guardar'), onPressed: (){
            final privilegioActualizado = privilegio.copyWith(
              type: typeController.text,
              userId: userController.text,
              guidelines: guidelinesController.text
            );
            
            Navigator.of(contextEditPrivilege).pop(privilegioActualizado);

          })
        ],
      );
    },
  );
}