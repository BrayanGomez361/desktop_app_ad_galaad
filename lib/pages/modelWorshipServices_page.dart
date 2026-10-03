
import 'package:ad_galaad_app/functions/createWorshipServiceTypeForm_function.dart';

import 'package:ad_galaad_app/providers/local_constants_provider.dart';


import 'package:ad_galaad_app/widgets/formatServiceCard_widget.dart';
import 'package:ad_galaad_app/widgets/textBtnClickable_widget.dart';

import 'package:fluent_ui/fluent_ui.dart'  hide Card;
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';


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
                      /*
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        // Estado: Presionado (Pressed)
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.blue.darker;
                        }
                        // Estado: Puntero encima (Hovered)
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.blue.lighter;
                        }
                        // Estado: Deshabilitado (Disabled)
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.grey.withOpacity(0.3);
                        }
                        // Estado por defecto (Normal)
                        return Colors.blue;
                      }),
                      */
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

                  /*
                FlyoutTarget(
                  controller: _flyoutController,
                  child: IconButton (
                    icon: const Icon(FluentIcons.more, size: 18),
                    onPressed: () {
                      
                      _flyoutController.showFlyout(
                        
                        placementMode: FlyoutPlacementMode.bottomLeft,
                        builder: (contextFlyout) {
                          return MenuFlyout(
                            items: [
                              
                              MenuFlyoutItem(
                                leading: const Icon(FluentIcons.pdf),
                                text: const Text('Exportar PDF'),
                                onPressed: ()async {
                                  Flyout.of(contextFlyout).close();
 
                                },
                              ),

                             
                              
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                */



              ],
            )
            
            

          ],
        ),
      ),






      content: Padding(
        padding: EdgeInsets.only(left:8.0, top:8, right: 8.0),
        child: CustomScrollView(
          
          slivers: [
            
            


            
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: formatos.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: FluentTheme.of(context).accentColor.normal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FluentIcons.modeling_view,
                                size: 40,
                                color: FluentTheme.of(context).accentColor.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            
                            Text(
                              'No hay formatos de cultos disponibles',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            /*
                            SizedBox(
                              width: 220,
                              child: FilledButton(
                                onPressed: () {
                                  
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.add, size: 14),
                                    SizedBox(width: 8),
                                    Text('Agregar anuncio'),
                                  ],
                                ),
                              ),
                            ),
                            */

                          ],
                        ),
                      ),
                    )
                  : 
                  
                  SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 10.0,    
                      runSpacing: 10.0,
                      
                      children: formatos.map((item) {
                        return FormatServiceCard(
                          formato: item,
                        );
                      }).toList(),
                    ),
                  ),
            ),
                        
                        
                        
                      
             


            /*
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        // Estado: Presionado (Pressed)
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.blue.darker;
                        }
                        // Estado: Puntero encima (Hovered)
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.blue.lighter;
                        }
                        // Estado: Deshabilitado (Disabled)
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.grey.withOpacity(0.3);
                        }
                        // Estado por defecto (Normal)
                        return Colors.blue;
                      }),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.add, size: 14,),
                        SizedBox(width: 12),
                        Text('Agregar programa de cultos', 
                          
                        ),
                      ],
                    ), 
                    onPressed: (){
                      
                      mostrarDialogCrearNuevoFormatoDePrograma(context, null);
                    }
                  ),
                  
                ],
              ),
            ),
            */

            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            )
        
          ],


        ),
      )
      
      
    );
  }
}

