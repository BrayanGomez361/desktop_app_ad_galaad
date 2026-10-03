

import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';

import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:provider/provider.dart';

// Diálogo sencillo para crear un usuario rápidamente
  void mostrarDialogoCambiarTipoDeCulto(BuildContext context, WorshipService culto) async {
    
    

    
    final typeController = TextEditingController( text: culto.type);

    List<AutoSuggestBoxItem<WorshipServiceFormat >> formatosDeCultos = await context.read<LocalConstantsProvider>().formatos.map(
      (element) {
        return AutoSuggestBoxItem<WorshipServiceFormat>(
          value: element, label: element.type
        );
      }
    ).toList();


    

    

    showDialog(
      context: context,
      builder: (contextDialog) {
        return ContentDialog(
          title: const Text('Cambiar tipo de culto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              /*
              AutoSuggestBox(
                autofocus: true,
                controller: typeController,
                items: _opcionesServicio,
                style: TextStyle(
                  overflow: TextOverflow.fade
                ),
                placeholder: 'Tipo de culto',
              ),
              */

              AutoSuggestBox(
                autofocus: true,
                controller: typeController,
                items: formatosDeCultos,
                style: TextStyle(
                  overflow: TextOverflow.fade
                ),
                placeholder: 'Tipo de culto',
              ),


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

                if ( typeController.text.isNotEmpty ) {
                  context.read<LocalWorshipServicesProvider>().actualizarCulto(
                    culto.copyWith(
                      type: typeController.text
                    )
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