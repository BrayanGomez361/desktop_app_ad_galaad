import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';

import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


void mostrarDialogoNuevoPrograma(BuildContext context, int index, String weekId) async {

  final String dateFormat = "dd MMMM 'del 20'yy 'a las' hh:mm a";

  DateTime selectedDate = DateTime.now();
  
  // Color por defecto inicial (Negro)
  Color selectedColor = Colors.black;

  final dateTimeController = TextEditingController(
    text: DateFormat(dateFormat, 'es').format(selectedDate),
  );
  final typeController = TextEditingController();

  // Definimos una lista de colores sugeridos para la paleta
final List<Color> paletaColores = [
  Colors.black,
  const Color(0xFF795548), // Café / Marrón
  const Color(0xFF800020), // Corinto / Vino
  const Color(0xFF9E9E9E), // Gris
  const Color(0xFFFFEB3B), // Amarillo
  const Color(0xFF1E88E5), // Azul ecad
  const Color(0xFF43A047), // Verde esc dom
  const Color(0xFF8E24AA), // Púrpura
  const Color(0xFFFB8C00), // Naranja
  const Color(0xFFE53935), // Rojo cmf
  const Color(0xFF00ACC1), // Cían
  const Color(0xFF5E35B1), // Índigo
];

// Creamos un controlador para el Flyout de color
final FlyoutController colorFlyoutController = FlyoutController();

  // Mapeamos los elementos agregando un punto de color visual en la lista desplegable
  /*
  List<AutoSuggestBoxItem<WorshipServiceType>> opcionesServicio = WorshipServiceType.values.map(
    (tipo) {
      return AutoSuggestBoxItem<WorshipServiceType>(
        value: tipo, // Guardamos el Enum completo como valor
        label: tipo.etiqueta,
        child: Row(
          children: [
            // Círculo con el color de la sugerencia
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: tipo.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                tipo.etiqueta,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
    },
  ).toList();
  */

  List<AutoSuggestBoxItem<WorshipServiceFormat>> formatosDeCultos = await context.read<LocalConstantsProvider>().formatos.map(
    (element) {
      return AutoSuggestBoxItem<WorshipServiceFormat>(
        value: element, label: element.type
      );
    }
  ).toList();


  showDialog(
    context: context,
    builder: (contextDialog) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return ContentDialog(
            title: const Text('Agregar un nuevo programa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                // Campo de AutoSuggest con selección de color automática
                Row(
                  spacing: 8.0,
                  children: [

                    /*
                    Expanded(
                      child: AutoSuggestBox<WorshipServiceType>(
                        autofocus: true,
                        controller: typeController,
                        items: opcionesServicio,
                        placeholder: 'Tipo de culto',
                        onSelected: (item) {
                          // Cuando el usuario hace clic en una sugerencia:
                          if (item.value != null) {
                            setStateDialog(() {
                              selectedColor = item.value!.color;
                            });
                          }
                        },
                      ),
                    ),
                    */

                    Expanded(
                      child: AutoSuggestBox<WorshipServiceFormat>(
                        autofocus: true,
                        controller: typeController,
                        items: formatosDeCultos ,//opcionesServicio,
                        placeholder: 'Tipo de culto',
                        onSelected: (item) {
                          // Cuando el usuario hace clic en una sugerencia:
                          if (item.value != null) {
                            setStateDialog(() {
                              selectedColor = item.value!.color;
                              selectedDate = selectedDate.copyWith(
                                hour: item.value!.dateTime.hour,
                                minute: item.value!.dateTime.minute,
                              );

                              dateTimeController.text = DateFormat(dateFormat, 'es').format(selectedDate);

                            });
                          }
                        },
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
                              builder: (contextFlyout) {
                                return FlyoutContent(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Seleccionar color',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      // Cuadrícula de paleta de colores
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: paletaColores.map((colorItem) {
                                          return GestureDetector(
                                            onTap: () {
                                              setStateDialog(() {
                                                selectedColor = colorItem; // Cambia el color seleccionado
                                              });
                                              Flyout.of(contextFlyout).close(); // Cierra la paleta
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: colorItem,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: selectedColor == colorItem
                                                      ? FluentTheme.of(context).accentColor
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*
                    // Muestra/Indicador del color seleccionado
                    Tooltip(
                      message: 'Color del culto',
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
                      ),
                    ),*/
                  ],
                ),
                /*
                Row(
                  children: [
                    Expanded(
                      child: AutoSuggestBox<WorshipServiceFormat>(
                        autofocus: true,
                        controller: typeController,
                        items: formatosDeCultos ,//opcionesServicio,
                        placeholder: 'Tipo de culto',
                        onSelected: (item) {
                          // Cuando el usuario hace clic en una sugerencia:
                          if (item.value != null) {
                            setStateDialog(() {
                              selectedColor = item.value!.color;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),*/

                // Selección de Fecha y Hora
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: TextBox(
                        controller: dateTimeController,
                        placeholder: 'Fecha y hora',
                        enabled: false,
                      ),
                    ),
                    Button(
                      child: const Icon(FluentIcons.calendar),
                      onPressed: () async {
                        // Lógica para abrir selector de fecha / hora...

                        final Color surfaceColor = FluentTheme.of(contextDialog).micaBackgroundColor;

                        // 2. Abrir selector de fecha
                        final DateTime? pickedDate = await material.showDatePicker(
                          context: contextDialog,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return material.Theme (
                                data: material.ThemeData.dark().copyWith(
                                  colorScheme: material.ColorScheme.dark(
                                    surface: surfaceColor,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: surfaceColor,
                                ),
                                child: child!,
                              );
                          },
                        );

                        if (pickedDate != null && contextDialog.mounted) {
                          // 3. Abrir selector de hora
                          final material.TimeOfDay? pickedTime = await material.showTimePicker(
                            
                            context: contextDialog,
                            initialTime: material.TimeOfDay.fromDateTime(selectedDate),
                            builder: (context, child) {
                              return material.Theme(
                                data: material.ThemeData.dark().copyWith(
                                  colorScheme: material.ColorScheme.dark(
                                    surface: surfaceColor,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: surfaceColor,
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedTime != null) {
                            // 4. Actualizar el estado interno del diálogo
                            setStateDialog(() {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              
                              // Actualizamos la caja de texto
                              dateTimeController.text = DateFormat(dateFormat, 'es').format(selectedDate);
                            });
                          }
                        }
                      

                        // ********************
                      },
                    )
                  ],
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
                  if (typeController.text.isNotEmpty) {
                    context.read<LocalWorshipServicesProvider>().agregarCulto(
                      WorshipService(
                        weekId: weekId,
                        order: index,
                        type: typeController.text,
                        dateTime: selectedDate,
                        privileges: [],
                        lastUpdated: {'': DateTime.now()},
                        color: selectedColor
                        // Puedes pasar selectedColor si tu modelo WorshipService acepta campo de color
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
    },
  );
}

/*
void mostrarDialogoNuevoPrograma(BuildContext context, int index, String weekId)  {
  final String dateFormat = "dd MMMM 'del 20'yy 'a las' hh:mm a";
  DateTime selectedDate = DateTime.now(); // Debe poder reasignarse

  Color selectedColor = Colors.black;

  final dateTimeController = TextEditingController(
    text: DateFormat(dateFormat, 'es').format(selectedDate),
  );
  final typeController = TextEditingController();

  List<AutoSuggestBoxItem<String>> _opcionesServicio = WorshipServiceType.values.map(
    (tipo) {
      return AutoSuggestBoxItem<String>(
        value: tipo.etiqueta,
        label: tipo.etiqueta,
        child: Text(
          tipo.etiqueta,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      );
    },
  ).toList();

  showDialog(
    context: context,
    builder: (contextDialog) {
      // 1. Usamos StatefulBuilder para reconstruir solo la UI del diálogo
      return StatefulBuilder(
        builder: (context2, setStateDialog) {
          return ContentDialog(
            title: const Text('Agregar un nuevo programa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                Text('$weekId'),
                AutoSuggestBox(
                  autofocus: true,
                  controller: typeController,
                  items: _opcionesServicio,
                  style: const TextStyle(overflow: TextOverflow.fade),
                  placeholder: 'Tipo de culto',
                ),

                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: TextBox(
                        controller: dateTimeController,
                        placeholder: 'Fecha y hora',
                        enabled: false,
                      ),
                    ),
                    Button(
                      child: const Icon(FluentIcons.calendar),
                      onPressed: () async {

                        final Color surfaceColor = FluentTheme.of(contextDialog).micaBackgroundColor;

                        // 2. Abrir selector de fecha
                        final DateTime? pickedDate = await material.showDatePicker(
                          context: contextDialog,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return material.Theme (
                                data: material.ThemeData.dark().copyWith(
                                  colorScheme: material.ColorScheme.dark(
                                    surface: surfaceColor,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: surfaceColor,
                                ),
                                child: child!,
                              );
                          },
                        );

                        if (pickedDate != null && contextDialog.mounted) {
                          // 3. Abrir selector de hora
                          final material.TimeOfDay? pickedTime = await material.showTimePicker(
                            context: contextDialog,
                            initialTime: material.TimeOfDay.fromDateTime(selectedDate),
                            builder: (context, child) {
                              return material.Theme(
                                data: material.ThemeData.dark().copyWith(
                                  colorScheme: material.ColorScheme.dark(
                                    surface: surfaceColor,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: surfaceColor,
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedTime != null) {
                            // 4. Actualizar el estado interno del diálogo
                            setStateDialog(() {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              
                              // Actualizamos la caja de texto
                              dateTimeController.text = DateFormat(dateFormat, 'es').format(selectedDate);
                            });
                          }
                        }
                      },
                    )
                  ],
                ),

                
              ],
            ),
            actions: [
              Button(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(contextDialog),
              ),
              FilledButton (
                child: const Text('Guardar'),
                onPressed: () {
                  if (typeController.text.isNotEmpty) {
                    context.read<LocalWorshipServicesProvider>().agregarCulto(
                      WorshipService(
                        weekId: weekId,
                        order: index,
                        type: typeController.text,
                        dateTime: selectedDate, // Pasa la fecha recién elegida
                        privileges: [],
                        lastUpdated: {'': DateTime.now()},
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
    },
  );
}
*/