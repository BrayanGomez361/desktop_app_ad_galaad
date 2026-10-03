
import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/functions/confirmDialog_funtion.dart';
import 'package:ad_galaad_app/functions/globalFunctions/showDatePicker_function.dart';
import 'package:ad_galaad_app/functions/globalFunctions/showTimePicker.dart';
import 'package:ad_galaad_app/functions/globalFunctions/showWorshipServiceFormatPicker_function.dart';
import 'package:ad_galaad_app/functions/mostrarDialogoCambiarColor_function.dart';
import 'package:ad_galaad_app/functions/showFormWorshipServiceType.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:ad_galaad_app/widgets/privilegeCard_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class WorshipServiceCardWidget extends StatefulWidget {
  final WorshipService culto;
  //final String? weekId;
  //final String? worshipServiceId;
  final List<Privilege> _privilegios;
  
  const new({
    super.key,
    required this.culto,
    //required this.weekId,
    required this._privilegios,
    required this._opciones,
    //required this.worshipServiceId
  });

  final List<AutoSuggestBoxItem <String>> _opciones;

  @override
  State<WorshipServiceCardWidget> createState() => _WorshipServiceCardWidgetState();
}

class _WorshipServiceCardWidgetState extends State<WorshipServiceCardWidget> {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('EEEE d','es').format(widget.culto.dateTime).toUpperCase();
    final hora = DateFormat('hh:mm a','es').format(widget.culto.dateTime);

    return material.Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)
      ),
      color: widget.culto.color.withOpacity(0.2),
      margin: EdgeInsets.only(bottom: 24, top: 8.0),
      child: Column(
        spacing: 8.0,
        children: [
          
          ListTile(
            margin: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 12.0,
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        
                        
                        fecha,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        
                        
                        '${widget.culto.type} a las $hora',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                      ),

                      Text('${widget.culto.order}'),



                    ],
                  ),
                ),

                FlyoutTarget(
                  controller: _flyoutController,
                  child: IconButton (
                    icon: const Icon(FluentIcons.more, size: 18), // Icono de ellipsis (...)
                    onPressed: () {
                      // 3. Abrir el menú flotante al hacer clic
                      _flyoutController.showFlyout(
                        //autoDismissible: true,
                        //barrierDismissible: true,
                        
                        placementMode: FlyoutPlacementMode.bottomLeft,
                        builder: (contextFlyout) {
                          return MenuFlyout(
                            items: [
                              
                              MenuFlyoutItem(
                                leading: Icon(
                                  FluentIcons.calendar,
                                  //color: Colors.red,
                                ),
                                text: Text(
                                  'Cambiar fecha y hora',
                                  //style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();
                                  DateTime selectedDate = widget.culto.dateTime;

                                  final DateTime? pickedDate = await mostrarDatePicker(context, selectedDate);

                                  if ( pickedDate != null && context.mounted) {
                                    final material.TimeOfDay? pickedTime = await mostrarSelectorHora(context, material.TimeOfDay.fromDateTime(widget.culto.dateTime));

                                    if (pickedTime != null) {
                                      selectedDate = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        pickedTime.hour,
                                        pickedTime.minute,
                                      );
                                    }

                                    final cultoActualizado = widget.culto.copyWith(
                                      dateTime: selectedDate,
                                    );
                                    context.read<LocalWorshipServicesProvider>().actualizarCulto(cultoActualizado);

                                  }

                                },
                              ),

                              
                              MenuFlyoutItem(
                                leading: Icon(
                                  FluentIcons.category_classification,
                                  //color: Colors.red,
                                ),
                                text: Text(
                                  'Cambiar nombre del culto',
                                  //style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  
                                  Flyout.of(contextFlyout).close();
                                  mostrarDialogoCambiarTipoDeCulto(context, widget.culto);
                                  
                                },
                              ),

                              MenuFlyoutItem(
                                leading: Icon(
                                  FluentIcons.color,
                                  //color: Colors.red,
                                ),
                                text: Text(
                                  'Cambiar color',
                                  //style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();
                                  mostrarDialogoCambiarColor(context, widget.culto);
                                },
                              ),

                              MenuFlyoutItem(
                                leading: Icon(
                                  FluentIcons.bulleted_list,
                                  //color: Colors.red,
                                ),
                                text: Text(
                                  'Aplicar un formato de programa',
                                  //style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();
                                  final WorshipServiceFormat? formatoSeleccionado = await mostrarSelectorDeFormatoDeCulto(context);



                                  if (formatoSeleccionado != null && formatoSeleccionado.privileges.isNotEmpty) {

                                    final bool confirmacion = await mostrarDialogoDeConfirmacion(
                                      context: context, 
                                      titulo: 'Actualizar privilegios de este programa', 
                                      mensaje: '¿Desea conservar los privilegios actuales?',
                                      textoConfirmar: 'Si',
                                      textoCancelar: 'No'
                                    );

                                    if (confirmacion == false) {
                                      await context.read<LocalPrivilegeStorageProvider>().eliminarPrivilegiosPorCultoId(widget.culto.id);
                                      //setState(() {});
                                    }

                                    setState(() {});

                                    // Cantidad de privilegios actuales para mantener el orden secuencial
                                    final int ordenInicial = widget._privilegios.length;

                                    // Mapeamos los privilegios del formato para asociarlos a este culto/servicio específico
                                    final List<Privilege> nuevosPrivilegios = formatoSeleccionado.privileges.asMap().entries.map((entry) {
                                      final int index = entry.key;
                                      final Privilege privilegioFormato = entry.value;

                                      return Privilege(
                                        id: DateTime.now().millisecondsSinceEpoch.toString() + '_$index', // ID único para el nuevo privilegio
                                        weekId: widget.culto.weekId,
                                        serviceId: widget.culto.id,
                                        order: ordenInicial + index, // Orden correlativo
                                        type: privilegioFormato.type,
                                        userId: privilegioFormato.userId,
                                        guidelines: privilegioFormato.guidelines,
                                        isAnnouncement: false,
                                      );
                                    }).toList();

                                    // Insertamos la lista de una sola vez
                                    await context.read<LocalPrivilegeStorageProvider>().agregarListaDePrivilegios(nuevosPrivilegios);
                                  }

                                },
                              ),


                              const MenuFlyoutSeparator(), // Línea divisoria

                              // Acción 3: Eliminar
                              MenuFlyoutItem(
                                leading: Icon(
                                  FluentIcons.delete,
                                  color: Colors.red,
                                ),
                                text: Text(
                                  'Eliminar semana',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();

                                  final confirmar = await mostrarDialogoDeConfirmacion (
                                    context: context,
                                    titulo: 'Eliminar programa de culto',
                                    mensaje: '¿Estás seguro de que deseas eliminar: ${widget.culto.type} y todos los privilegios asociados? Esta acción no se puede deshacer.',
                                    textoConfirmar: 'Eliminar',
                                  );
                                                    
                                  if (confirmar && context.mounted) {
                                    await context
                                        .read<LocalWorshipServicesProvider>()
                                        .eliminarCultoYPrivilegiosAsociados(context, widget.culto.id);
                                  }
                                //await context.read<LocalWorshipServicesProvider>().eliminarCultoYPrivilegiosAsociados(context, widget.culto.id);
                                
                                },
                              ),


                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
    
                
              ],
            ),
            
          ),
    
          //SizedBox(height: 4.0,),
          
              ListTile(
                contentPadding: EdgeInsets.only(top: 4.0, bottom: 4.0, left:8.0, right: 16.0),
                margin: EdgeInsets.only(top: 0.0),
                //leading: Icon(FluentIcons.contact, size: 15,),
                title: Row(
                  //spacing: 8.0,
                  children: [
                    Expanded(
                      flex:2,
                      child: Text(
                        'Privilegio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Encargado del privilegio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                      
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Indicaciones sobre el privilegio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                    Expanded(
                      flex:1,
                      child: Text(
                        '',
                        
                        
                      ),
                    ),
                  ],
                ),
              
                
                //onPressed: () {},
              ),
          

          
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget._privilegios.length,
            // Desactiva el icono de arrastre por defecto de Flutter para usar el nuestro al final
            buildDefaultDragHandles: false, 
            onReorder: (oldIndex, newIndex) async {
              
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                 // 1. Reordenar el elemento en la lista local
                final item = widget._privilegios.removeAt(oldIndex);
                widget._privilegios.insert(newIndex, item);

                // 2. Asignar el nuevo valor de 'order' a cada objeto en la lista
                for (int i = 0; i < widget._privilegios.length; i++) {
                  widget._privilegios[i] = widget._privilegios[i].copyWith(order: i);
                }

                // 3. Notificar y guardar todos los cambios de una sola vez
                await context
                    .read<LocalPrivilegeStorageProvider>()
                    .actualizarOrdenesPrivilegios(widget._privilegios);

                // 4. Rediseñar la vista para reflejar el nuevo orden en pantalla
                if (mounted) {
                  setState(() {});
                }

            },
            itemBuilder: (context, index) {
              final item = widget._privilegios[index];

              return Column(
                // La Key es OBLIGATORIA para los hijos de un ReorderableListView
                key: ValueKey(item.id),
                children: [
                  PrivilegeCardWidget(
                    index: index,
                    privilegio: item,
                    opciones: widget._opciones,
                    onDelete: () async {
                      final confirmar = await mostrarDialogoDeConfirmacion (
                        context: context, 
                        titulo: 'Eliminar privilegio', 
                        mensaje: '¿Estás seguro de que deseas eliminar este privilegio? Esta acción no se puede deshacer.'

                      );

                      if (confirmar && context.mounted) {
                        await context.read<LocalPrivilegeStorageProvider>().eliminarPrivilegio(item.id);

                        widget._privilegios.removeWhere((p) => p.id == item.id);
                      await context
                        .read<LocalPrivilegeStorageProvider>()
                        .actualizarOrdenesPrivilegios(widget._privilegios);
                      }
                      
                    },
                  ),
                  // Simulación de la línea divisoria (Divider) entre elementos
                  if (index < widget._privilegios.length - 1)
                    const Divider(
                      size: 1.0,
                      style: DividerThemeData(
                        horizontalMargin: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                    ),
                ],
              );
            },
          ),
          //SizedBox(height: 8.0,),

          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Column(
              children: [
                Visibility(
                  visible: widget._privilegios.isEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                            
                            // Texto de estado vacío más estilizado
                            Text(
                              'No hay privilegios en este programa de culto',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                    ],
                  )
                ),
                
                SizedBox(
                  width: 250,
                  child: Button(
                    
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16.0,
                      children: [
                        Icon(CupertinoIcons.add, color: CupertinoColors.activeGreen,),
                        Text('Agregar privilegio',
                          style: TextStyle(
                            color: CupertinoColors.activeGreen
                          ),
                        ),
                      ],
                    ),
                    onPressed: (){
                      
                      context.read<LocalPrivilegeStorageProvider>().agregarPrivilegio(
                        Privilege(
                          order: widget._privilegios.length,
                          weekId: widget.culto.weekId,
                          serviceId: widget.culto.id,
                          type: null,
                          isAnnouncement: false,
                          
                        )
                      );
                      
                      
                    }
                  ),
                ),
              ],
            ),
          ),

          

          SizedBox(height: 8.0,),
    
    
        ],
      ),
    );
  }
}


