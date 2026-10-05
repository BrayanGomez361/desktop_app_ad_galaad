import 'package:ad_galaad_app/classes/weeks_class.dart';

import 'package:ad_galaad_app/pages/modelWorshipServices_page.dart';
import 'package:ad_galaad_app/pages/weekView_page.dart';
//import 'package:ad_galaad_app/providers/local_privileges_provider.dart';

import 'package:ad_galaad_app/providers/local_weeks_provider.dart';
//import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';

import 'package:fluent_ui/fluent_ui.dart'  hide Colors;
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';


// Vista Principal: Sistema
class MonthlyWeeksPage extends StatefulWidget {
  const MonthlyWeeksPage({super.key});

  @override
  State<MonthlyWeeksPage> createState() => _MonthlyWeeksPageState();
}

class _MonthlyWeeksPageState extends State<MonthlyWeeksPage> {

  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose(); // Limpiar el controlador
    super.dispose();
  }
  //static const double _thresholdWidth = 1200.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalWeeksStorageProvider>();

    //final provider2 = context.watch<LocalWorshipServicesProvider>();
    //final provider3 = context.watch<LocalPrivilegeStorageProvider>();

    //final double screenWidth = MediaQuery.of(context).size.width;
    

    // 1. Estado de carga inicial
    if (provider.cargando) {
      return const Center(
        child: ProgressRing(),
      );
    }

    if (provider.semanas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.doc_library, size: 40.0),
            const SizedBox(height: 12),
            const Text(
              'No hay semanas agendadas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => provider.agregarSemana(WeeklySchedule( titulo: 'Programas de la semana', announcements: [], programs: [])),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.add_medium , size: 14),
                  SizedBox(width: 8),
                  Text('Agregar primer semana'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ScaffoldPage(
      
      header: PageHeader(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Programas de cultos'),

            FlyoutTarget(
              controller: _flyoutController, 
              child: IconButton(
                icon: Icon(FluentIcons.more),
                onPressed: (){
                  _flyoutController.showFlyout(
                    placementMode: FlyoutPlacementMode.bottomLeft,
                    builder: (contextFlyout) {
                      return MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            text: Row(
                              spacing: 8.0,
                              children: [
                                Icon(FluentIcons.add),
                                Text('Crear una semana'),
                              ],
                            ), 
                            onPressed: () async {
                              Flyout.of(contextFlyout).close(); // Cerrar el menú
                                  //widget.onEditar(); // Ejecutar la función
                                  await context.read<LocalWeeksStorageProvider>().agregarSemana(WeeklySchedule( titulo: 'Programas de la semana', announcements: [], programs: []));
                  
                            }
                          ),

                          MenuFlyoutItem(
                            text: Row(
                              spacing: 8.0,
                              children: [
                                Icon(FluentIcons.view),
                                Text('Ver formatos de programas'),
                              ],
                            ), 
                            onPressed: () async {
                              Flyout.of(contextFlyout).close();
                              
                              Navigator.of(context).push(
                                CupertinoPageRoute(builder: (context) => ModelWeekViewPage() ,)
                              );
                            }
                          ),

                        ],
                      );
                    },
                  );
                }, 
              )
            ),

            /*
            Row(
              spacing: 12.0,
              children: [
                Button(
                  child: Row(
                    spacing: 8.0,
                    children: [
                      Icon(FluentIcons.add),
                      Text('Crear una semana'),
                    ],
                  ), onPressed: () async {
                    await context.read<LocalWeeksStorageProvider>().agregarSemana(WeeklySchedule( titulo: 'Programas de la semana', announcements: [], programs: []));
                  }
                ),

            Button(
              child: Row(
                spacing: 8.0,
                children: [
                  Icon(FluentIcons.view),
                  Text('Ver formatos de programas'),
                ],
              ), onPressed: () async {
                //await context.read<LocalWeeksStorageProvider>().agregarSemana(WeeklySchedule( titulo: 'Programas de la semana', announcements: [], programs: []));
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => ModelWeekViewPage() ,)
                );
              }
            ),



              ],
            ),
            */
            
          ],
        )
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18.0),
        child: Column(
          
          //padding: const EdgeInsets.all(16),
          children: [
            // Botón estilo Cupertino/Fluent para ir a la subpantalla
            

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.semanas.length,
              
              itemBuilder: (context,index){
                final semana = provider.semanas[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    /*
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    */
                    borderRadius: BorderRadiusGeometry.circular(6.0),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsetsGeometry.all(0),
                    child: Column(
                      children: [
                        ListTile(
                          margin: EdgeInsets.zero,
                          contentPadding: EdgeInsetsGeometry.symmetric(vertical: 18, horizontal: 12),
                          leading: Icon(CupertinoIcons.list_bullet_below_rectangle , size: 25,),
                          title: Row(
                            children: [
                              Text(semana.titulo,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                               ),
                  
                               
                  
                  
                            ],
                          ),
                          
                          subtitle: Row(
                            spacing: 18.0,
                            children: [
                              Text( 'Semana ${index+1}'),
                              //Text('Anuncios asociados: ${semana.announcements.length}'),
                              //Text('Programas de culto asociados: ${semana.programs.length}'),
                              
                            ],
                          ),
                          
                          trailing: Row(
                            spacing: 16,
                            children: [
                               Icon( 
                            semana.isCurrentWeek ? FluentIcons.completed_solid : FluentIcons.erase_tool,
                          size: 20,
                          color: semana.isCurrentWeek ? CupertinoColors.activeGreen : CupertinoColors.inactiveGray ,
                          ),
                  
                              const Icon(CupertinoIcons.chevron_forward),
                            ],
                          ),
                          onPressed: () {
                            // Navega dentro del área de contenido sin ocultar el menú lateral
                            if(semana.weekId != null){
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => WeekViewPage( index: (index+1).toString(), semana: semana,   weekId: semana.weekId!),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),

/*
            Column(
              children: [
                Text('Resumen de los datos almacenados en memoria local:'),

                Text('Semanas creadas: ${provider.semanas.length}'),

                Text('Cultos creados : ${provider2.cultos.length}'),

                Text('Privilegios creados de forma general: ${provider3.privilegios.length}'),
              ],
            ),*/

            



            
            
          ],
        ),
      ),
    );
  }
}