
import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/functions/createWorshipServiceTypeForm_function.dart';

import 'package:ad_galaad_app/providers/local_constants_provider.dart';


import 'package:ad_galaad_app/widgets/formatServiceCard_widget.dart';
import 'package:ad_galaad_app/widgets/textBtnClickable_widget.dart';

import 'package:fluent_ui/fluent_ui.dart'  hide Card;
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';


class ModelWeekViewPage extends StatefulWidget {


  const ModelWeekViewPage({
    super.key,
    
  });

  @override
  State<ModelWeekViewPage> createState() => _ModelWeekViewPageState();
}

class _ModelWeekViewPageState extends State<ModelWeekViewPage> {

  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localProvider = context.watch<LocalConstantsProvider>();


    final formatos = localProvider.formatos;


    return ScaffoldPage(
      header: PageHeader(
        
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8.0,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.0,
              children: [
                TextBtnClickeable(texto: 'Programas de cultos', onTap: (){
                            if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                          },
                          useEfect: true,),

             Icon(CupertinoIcons.forward, size: 18, color: Colors.white.withOpacity(0.3),),

           TextBtnClickeable(
            texto: 'Formatos de programas', onTap: (){}),



              ],
            ),

           

          

 

            
           

            

            Row(
              spacing: 12.0,
              children: [

                Button(
                    style: ButtonStyle(
                      
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.hammer , size: 16,),
                        SizedBox(width: 12),
                        Text('Crear nuevo formato', 
                          
                        ),
                      ],
                    ), 
                    onPressed: (){
                      
                      mostrarDialogCrearEditarNuevoFormatoDePrograma(context, null, formatos.length);
                    }
                  ),

                  



              ],
            )
            
            

          ],
        ),
      ),






      content: CustomScrollView(
        slivers: [
          
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: ReorderableSliverGridView (
              // Parámetros obligatorios de layout
              crossAxisCount: 3, // Número de columnas
              mainAxisSpacing: 12.0, // Espaciado vertical
              crossAxisSpacing: 12.0, // Espaciado horizontal
              childAspectRatio: 1.1, // Proporción Ancho / Alto de la tarjeta
        
              dragStartDelay: Duration.zero,
        
              // Callback de reordenamiento
              onReorder: (oldIndex, newIndex) {
                final listaActualizada = List<WorshipServiceFormat>.from(formatos);
                final item = listaActualizada.removeAt(oldIndex);
                listaActualizada.insert(newIndex, item);
        
                context.read<LocalConstantsProvider>().reordenarFormatos(listaActualizada);
              },
        
              // Generamos la lista de Widgets asignando a cada uno su Key
              children: formatos.map((formato) {
                return FormatServiceCard(
                  key: ValueKey(formato.id),
                  formato: formato,
                );
              }).toList(),
            ),
          ),      
                      
                      
                    
           
      
      
          
      
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          )
      
        ],
      
      
      )
      
      
    );
  }
}

