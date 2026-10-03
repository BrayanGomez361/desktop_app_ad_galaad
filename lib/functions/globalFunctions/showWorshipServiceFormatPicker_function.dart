



import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';


/// Utilidad:
/// Util para aplicar a un culto existente un formato de privilegios
Future<WorshipServiceFormat?> mostrarSelectorDeFormatoDeCulto(BuildContext context) async {
  WorshipServiceFormat? formatoSeleccionado;

  final List<WorshipServiceFormat> formatos = context.read<LocalConstantsProvider>().formatos;
  

  return await material.showDialog<WorshipServiceFormat>(
    context: context, 
    builder: (contextDialog) {
      return StatefulBuilder(
        
        builder: (context, setDialogState) {
          return ContentDialog(
            title: Text('Formato de cultos disponibles'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ComboBox<WorshipServiceFormat>(
                  value: formatoSeleccionado,
                  placeholder: const Text('Selecciona un formato de culto'),
                  isExpanded: true, // Ocupa todo el ancho disponible
                  items: formatos.map((formato) {
          
                    return ComboBoxItem<WorshipServiceFormat>(
                      value: formato,
                      child: Row(
                        children: [
                          // Indicador del color del formato
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: formato.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(formato.type),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (nuevoFormato) {
                    setDialogState(() {
                      formatoSeleccionado = nuevoFormato;
                    });
                  },
                ),

                const SizedBox(height: 16.0),

                if (formatoSeleccionado == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Selecciona un formato para ver sus privilegios.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else if (formatoSeleccionado!.privileges.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Este formato no tiene privilegios asignados.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  // 3. Renderizado de la lista de privilegios cuando sí existe selección
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: formatoSeleccionado!.privileges.length,
                      itemBuilder: (context, index) {
                        final privilegio = formatoSeleccionado!.privileges[index];
                        return Row(
                          spacing: 8.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                privilegio.type ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                privilegio.userId ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal, 
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                privilegio.guidelines ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal, 
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Divider(size: 0.5),
                        );
                      },
                    ),
                  ),
              ],
            ),
            actions: [
              Button(child: Text('Cancelar'), onPressed: (){
                Navigator.of(contextDialog).pop(null);
              }),
              FilledButton(
                child: Text('Guardar'), 
                onPressed: formatoSeleccionado == null 
                    ? null 
                    : () {
                        Navigator.of(contextDialog).pop(formatoSeleccionado);
                      },
            
                  //final privilegioActualizado = privilegio.copyWith(type: typeController.text,userId: userController.text,guidelines: guidelinesController.text);
            
                  
                  //Navigator.of(contextDialog).pop(privilegioActualizado);
            
                //}
              )
            ],
          );
        }
      );
    },
  );
}