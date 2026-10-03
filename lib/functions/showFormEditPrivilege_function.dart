

import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

// Diálogo sencillo para crear un usuario rápidamente
  void mostrarDialogoEditarPrivilegio(BuildContext context, Privilege actual, List<AutoSuggestBoxItem <String>> usuarios) {
    
    final typeController = TextEditingController( text: actual.type);
    final encargadoController = TextEditingController( text: actual.userId);
    final indicacionesController = TextEditingController( text: actual.guidelines );

    List<String> _tipos = [
      'Preside',
      'Himnos',
      'Lectura',
      'Ofrenda general',
      'Ofrenda pro-',
      'Coros',
      'Mensaje',
      'Enseñanza',
      'Anuncios por líderes',
      'Despide',
      'Tiempo de adoración',
      'Tiempo especial',
      'Ofrenda humanitaria',
      'Reporte',
      'Salida de niños',
      'Lectura',
    ];

    


    List<AutoSuggestBoxItem<String>> tiposAutocompletar = _tipos.map(
      (tipo) {
        return AutoSuggestBoxItem<String>(
          value: tipo, // El valor interno/seleccionado (o puedes usar tipo.name si prefieres el ID)
          label: tipo, // El texto visible en la lista desplegable de la sugerencia
          child: Text(
            tipo,
            maxLines: 1,
            overflow: TextOverflow.fade, // Recorta el texto con "..." si no cabe
          ),
        );
      },
    ).toList();

    

    showDialog(
      context: context,
      builder: (contextDialog) {
        return ContentDialog(
          title: const Text('Editar el privilegio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [

              AutoSuggestBox(
                autofocus: false,
                controller: typeController,
                items: tiposAutocompletar,
                style: TextStyle(
                  overflow: TextOverflow.fade
                ),
                placeholder: 'Tipo de privilegio...',
              ),
              
              AutoSuggestBox(
                autofocus: false,
                controller: encargadoController,
                items: usuarios,
                
                style: TextStyle(
                  overflow: TextOverflow.fade
                ),
                placeholder: 'Encargado...',
              ),


              TextBox(
                controller: indicacionesController,
                placeholder: 'Indicaciones...',
                maxLines: null,
                style: TextStyle(
                  fontStyle: FontStyle.italic
                ),
                
              )


            ],
          ),


          actions: [
            Button(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(contextDialog),
            ),

            FilledButton(
              child: Text('Guardar'),
              onPressed: () async {

                await context.read<LocalPrivilegeStorageProvider>().actualizarPrivilegio(
                  actual.copyWith(
                    type: typeController.text,
                    userId: encargadoController.text,
                    guidelines: indicacionesController.text
                  )
                );
                Navigator.pop(contextDialog);
                /*
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
                */
                /*
                if ( typeController.text.isNotEmpty ) {
                  context.read<LocalWorshipServicesProvider>().actualizarCulto(
                    culto.copyWith(
                      type: typeController.text
                    )
                  );

                  Navigator.pop(contextDialog);
                  
                }
                */


              },
            ),

          ],
        );
      },
    );
  }