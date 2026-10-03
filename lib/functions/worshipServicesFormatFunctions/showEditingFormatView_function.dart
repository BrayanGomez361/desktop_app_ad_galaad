

import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/functions/confirmDialog_funtion.dart';
import 'package:ad_galaad_app/functions/worshipServicesFormatFunctions/showEditPrivilegeForm_function.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

void mostrarPrivilegiosDeUnFormatoDelPrograma(BuildContext context, WorshipServiceFormat formato) async {
  //final copia = formato.privileges;

  final List<Privilege> copiaPrivilegios = formato.privileges
      .map((p) => p.copyWith()) // Asegúrate de que copyWith() sin argumentos clone el objeto
      .toList();

  showDialog(
    context: context, 
    builder: (contextDialog) {

      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return ContentDialog(
            constraints: const BoxConstraints(
              maxWidth: 600.0, // Ancho máximo deseado (ej. 600px, 800px)
              minWidth: 400.0, // Ancho mínimo sugerido
              maxHeight: 600.0,
            ),
            title: Text('Lista de privilegios'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                //ListView.builder(itemBuilder: itemBuilder)
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: copiaPrivilegios.length,
                    itemBuilder: (BuildContext context2, index) {
                  
                      final privilegio = copiaPrivilegios[index];
                  
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 8.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              privilegio.type ?? '',
                              
                              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 14  ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              privilegio.userId ?? '',
                              
                              style: TextStyle( fontWeight: FontWeight.normal, fontSize: 14  ),
                            ),
                          ),
                  
                          Flexible(
                            child: Text(
                              privilegio.guidelines ?? '',
                              
                              style: TextStyle( fontWeight: FontWeight.normal, fontSize: 14  ),
                            ),
                          ),
                          Row(
                            spacing: 8.0,
                            children: [
                              Button(
                                child: Icon(FluentIcons.edit), 
                                onPressed: () async {
                              
                                
                                final privilegioActualizado = await mostrarFormEditarPrivilegio(context, privilegio);
                  
                                if (privilegioActualizado != null) {
                                  setStateDialog((){
                                    copiaPrivilegios[index] = privilegioActualizado;
                                  });
                                  
                                }
                                
                              
                              
                              }),
                  
                          Button(
                            
                            onLongPress: () async {
                              final result = await mostrarDialogoDeConfirmacion (
                                context: contextDialog, titulo: 'Eliminar este privilegio',
                                 mensaje: 'Desea continuar con la eliminario de este privilegio del formato');
                  
                              if (result == true) {
                                setStateDialog((){
                                  
                                  copiaPrivilegios.removeAt(index);
                                });
                              }
                  
                              
                  
                            },
                            onPressed: null, 
                            child: Icon(FluentIcons.delete),
                  
                          )
                  
                            ],
                          ),
                          
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: const Divider(
                          size: 0.5,
                        ),
                      );
                    },
                  ),
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: FilledButton(
                        
                        child: Text('+ Agregar privilegio'), onPressed: (){
                                                                
                      
                        setStateDialog(() {
                          copiaPrivilegios.add(
                            Privilege(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              type: '', 
                              userId: '',
                              order: copiaPrivilegios.length
                            )
                            );
                          
                      
                                                                });
                        
                          
                                                                
                        
                      }
                      ),
                    ),
                  ]
                  
                )
              ],
            ),
            actions: [
              Button(child: Text('Cancelar'), onPressed: (){
                Navigator.of(contextDialog).pop();
              }),
              FilledButton(child: Text('Guardar'), onPressed: (){
                
                
                final formatoActualizado = formato.copyWith(
                    privileges: copiaPrivilegios,
                  );

                
                context.read<LocalConstantsProvider >().actualizarFormato(
                  formatoActualizado
                );
                
                Navigator.of(contextDialog).pop();
                
              })
            ],
          );
        }
      );
    },
  );
}