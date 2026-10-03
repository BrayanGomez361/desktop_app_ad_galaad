



import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/functions/globalFunctions/showTimePicker.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
//import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void mostrarDialogCrearEditarNuevoFormatoDePrograma(BuildContext context, WorshipServiceFormat? formatoActual, int indexSiguiente) async {
  final isEditing = (formatoActual != null);

  

  final List<Color> paletaColores = [
    Colors.black,
    const Color(0xFF795548), // Café / Marrón
    const Color(0xFF800020), // Corinto / Vino
    const Color(0xFF9E9E9E), // Gris
    //const Color(0xFFFFEB3B), // Amarillo
    const Color(0xFF1E88E5), // Azul ecad
    const Color(0xFF43A047), // Verde esc dom
    const Color(0xFF8E24AA), // Púrpura
    const Color(0xFFFB8C00), // Naranja
    const Color(0xFFE53935), // Rojo cmf
    const Color(0xFF00ACC1), // Cían
    const Color(0xFF5E35B1), // Índigo
  ];

  final ahora = DateTime.now();
  DateTime initialTime = DateTime(ahora.year, ahora.month,ahora.day,19,0,0) ;
  Color selectedColor = Colors.black;

  final typeController = TextEditingController();
  final horaController = TextEditingController(text: DateFormat('hh:mm a','es_ES').format(initialTime));
  final FlyoutController colorFlyoutController = FlyoutController();

  if (isEditing) {
    selectedColor = formatoActual.color;
    typeController.text = formatoActual.type;
    horaController.text =  DateFormat('hh:mm a','es_ES').format(formatoActual.dateTime) ;
  }

  List<AutoSuggestBoxItem<WorshipServiceFormat >> formatosDeCultos = await context.read<LocalConstantsProvider>().formatos.map(
      (element) {
        return AutoSuggestBoxItem<WorshipServiceFormat>(
          value: element, label: element.type
        );
      }
    ).toList();

  showDialog(
    context: context, 
    builder:(contextDialog) {
      return StatefulBuilder(
        builder:(context, setStateDialog) {
          return ContentDialog(
            title: isEditing
              ? Text('Editar formato de programa')
              : Text('Crear un nuevo formato de programa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [

                

                Row(
                  spacing: 8.0,
                  children: [
                    /*
                    Expanded(
                      child: TextBox(
                        placeholder: 'Tipo de culto',
                        controller: typeController,
                        maxLines: null,
                      ),
                    ),*/

                    Expanded(
                      child: AutoSuggestBox(
                        autofocus: true,
                        controller: typeController,
                        items: formatosDeCultos,
                        style: TextStyle(
                          overflow: TextOverflow.fade
                        ),
                        placeholder: 'Tipo de culto',
                      ),
                    ),
                    
                
                    FlyoutTarget(
                      controller: colorFlyoutController, 
                      child: Tooltip(
                        message: 'Hacer clic para cambiar color',
                        child: GestureDetector(
                          onTap: () {
                            colorFlyoutController.showFlyout(
                              placementMode: FlyoutPlacementMode.bottomRight,
                              builder:(contextFlyout) {
                                return FlyoutContent(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //spacing: 8.0,
                                    children: [
                                      const Text(
                                        'Seleccionar color',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      Wrap(
                                        spacing: 6.0,
                                        runSpacing: 6.0,
                                        children: paletaColores.map((colorItem){
                                          return GestureDetector(
                                            onTap: () {
                                              setStateDialog(() {
                                                selectedColor = colorItem;
                                              },);
                                              //Flyout.of(contextFlyout).close();
                                              colorFlyoutController.close();
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: colorItem,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: selectedColor == colorItem
                                                    ? FluentTheme.of(contextFlyout).accentColor
                                                    : Colors.transparent,
                                                  width: 2,
                                                )
                                              ),
                                            ),
                                        
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  )
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              FluentIcons.color,
                              size: 12,
                              color: material.Colors.white,
                            ),
                          ),
                        ),
                      )
                    )
                    
                  ],
                ),




                Row(
                  spacing: 8.0,
                  children: [
                    
                    Expanded(
                      child: TextBox(
                        placeholder: 'Horario del culto',
                        controller: horaController,
                        maxLines: null,
                        enabled: false,
                      ),
                    ),
                    Button(
                      child: Icon(FluentIcons.clock), 
                      onPressed: () async {
                        final material.TimeOfDay? pickedTime = await  mostrarSelectorHora(context, material.TimeOfDay.fromDateTime(initialTime));

                        if (pickedTime != null) {
                          setStateDialog((){
                            initialTime = initialTime.copyWith(
                              hour: pickedTime.hour,
                              minute: pickedTime.minute
                            );

                            horaController.text = DateFormat('hh:mm a','es_ES').format(initialTime);
                          });
                          

                        }

                      }
                    )
                  ],
                ),

                

/*
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: Row(
                        spacing: 12.0,
                        children: [
                          Icon(FluentIcons.add),
                          Text('Agregar privilegio'),
                        ],
                      ), 
                      onPressed: (){
                        _privilegios.add( Privilege(type: '', order: _privilegios.length));
                        setStateDialog(() {});
                      }
                    ),
                  ],
                )*/

              ],
            ),
            actions: [
              Button(child: const Text('Cancelar'), onPressed: (){
                Navigator.of(contextDialog).pop();
              }),
              FilledButton(
                child: const Text('Guardar'), 
                onPressed: (){
                  // Verificar
                  if ( typeController.text.isNotEmpty) {

                    if ( isEditing == true) {
                      context.read<LocalConstantsProvider>().actualizarFormato(
                        formatoActual!.copyWith(
                          type: typeController.text, 
                          color: selectedColor, 
                          dateTime: initialTime,
                        )
                      );
                      
                    }else{
                      context.read<LocalConstantsProvider>().agregarFormato(
                        WorshipServiceFormat(
                          order: indexSiguiente,
                          type: typeController.text, color: selectedColor,
                          dateTime: initialTime,
                          privileges: []
                        )
                      );
                    }

                    

                    Navigator.of(contextDialog).pop();
                  }
                  // Guardar en disco
                  
                }
              )
            ],
          );
        },
      );
    },
  );
}