import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/weeks_class.dart';
import 'package:ad_galaad_app/functions/actualizarTituloSemana_function.dart';
import 'package:ad_galaad_app/functions/confirmDialog_funtion.dart';
import 'package:ad_galaad_app/functions/mostrarDialogEditarTituloSemana.dart';
import 'package:ad_galaad_app/functions/showNewWorshipServiceForm_function.dart';
import 'package:ad_galaad_app/pages/pdfPreviewPage_page.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:ad_galaad_app/providers/local_weeks_provider.dart';
import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:ad_galaad_app/widgets/announcementsCard_widget.dart';
import 'package:ad_galaad_app/widgets/textBtnClickable_widget.dart';
import 'package:ad_galaad_app/widgets/worshipServiceCard_widget.dart';
import 'package:fluent_ui/fluent_ui.dart'  hide Card;
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';


class WeekViewPage extends StatefulWidget {
  final WeeklySchedule semana;
  final String? index;
  final String weekId;

  const WeekViewPage({
    super.key,
    required this.semana,
    required this.index,
    required this.weekId,
  });

  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  // 1. Crear el controlador del Flyout
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageProvider>();
    final privilegiosProvider = context.watch<LocalPrivilegeStorageProvider>();
    final cultosProvider = context.watch<LocalWorshipServicesProvider>();
    final semanasProvider = context.watch<LocalWeeksStorageProvider>();

    
    final indexSemana = semanasProvider.semanas.indexWhere((p) => p.weekId == widget.weekId);
    if (indexSemana == -1) {
      return const SizedBox.shrink();
    }

    final semanaActual = semanasProvider.semanas.where((p) => p.weekId == widget.weekId).first;

    final List<AutoSuggestBoxItem<String>> _opciones = localStorage.usuarios.map(
      (element){
        return AutoSuggestBoxItem(value: element.name, label: element.name);
      }).toList();

    final _weekPrivilegios = privilegiosProvider.privilegios.where(
      (item) => (item.weekId == widget.weekId)
    ).toList();

    //final anuncios = localStorage.;
    final anuncios = _weekPrivilegios.where(
      (item) => (item.isAnnouncement == true)
    ).toList()..sort((a, b) => (a.order).compareTo(b.order));



    final _cultos = cultosProvider.cultos.where(
      (item) => (item.weekId == widget.weekId )
    ).toList()..sort((a, b) => (a.order).compareTo(b.order));;

    return ScaffoldPage(
      header: PageHeader(
        // Historial estilo "Sistema > Pantalla > Administración del color"
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

           TextBtnClickeable(texto: 'Semana ${widget.index}', onTap: (){}),



              ],
            ),

           

          

 

            
           

            

            Row(
              spacing: 12.0,
              children: [


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
                              // Acción 1: Editar
                              MenuFlyoutItem(
                                leading: const Icon(FluentIcons.refresh ),
                                text: const Text('Actualizar titulo'),
                                onPressed: () async{
                                  Flyout.of(contextFlyout).close(); // Cerrar el menú
                                  //widget.onEditar(); // Ejecutar la función

                                  final result = await actualizarTituloSemana (_cultos, widget.semana);
                                  await context.read<LocalWeeksStorageProvider>().actualizarSemana(
                                    widget.semana.copyWith(
                                      titulo: result
                                    )
                                  );

                                  setState(() {
                                    
                                  });

                                },
                              ),

                              // Acción 2: Duplicar / Copiar
                              MenuFlyoutItem(
                                leading: const Icon(FluentIcons.pdf),
                                text: const Text('Exportar PDF'),
                                onPressed: ()async {
                                  Flyout.of(contextFlyout).close();
                                  // Lógica opcional
                                  /*
                                  Navigator.of(context).push(
                                  FluentPageRoute(
                                    builder: (context) => const PdfViewerPage(
                                      tituloSemana: 'Semana 1 - Semana del xx al yy de septiembre',
                                    ),
                                  ),*/


                                   Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => PdfViewerPage(
                                          title: semanaActual.titulo ,
                                          tituloSemana: 'Semana ${widget.index}',
                                          privilegios: _weekPrivilegios,
                                          cultos: _cultos,
                                          anuncios: anuncios,
                                        ),
                                      ),
                                    );




                                //);
                                  
                                },
                              ),

                              MenuFlyoutItem(
                                leading: const Icon( FluentIcons.completed),
                                text: const Text('Establecer como semana actual'),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();
                                  // Lógica opcional

                                  await context.read<LocalWeeksStorageProvider>().actualizarSemana(
                                    widget.semana.copyWith(
                                      isCurrentWeek: true
                                    )
                                  );

                                },
                              ),

                              MenuFlyoutItem(
                                leading: const Icon( FluentIcons.erase_tool),
                                text: const Text('Establecer como borrador'),
                                onPressed: () async {
                                  Flyout.of(contextFlyout).close();
                                  // Lógica opcional

                                  await context.read<LocalWeeksStorageProvider>().actualizarSemana(
                                    widget.semana.copyWith(
                                      isCurrentWeek: false
                                    )
                                  );

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
                                  //Navigator.of(context).pop();
                                  //widget.onEliminar(); // Ejecutar la función
                                  final confirmar = await mostrarDialogoDeConfirmacion(
                                    context: context, 
                                    titulo: 'Eliminar semana completa', 
                                    mensaje: '¿Estás seguro de que deseas eliminar esta semana con todos los cultos, servidores y anuncios asociados? Esta acción no se puede deshacer.'
                            
                                  );
                            
                                  if (confirmar && context.mounted) {
                                    Navigator.of(context).pop();
                                    await context.read<LocalWeeksStorageProvider>().eliminarSemanaCompleta(context, widget.weekId);
                                    
                                  }
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
            )
            
            

          ],
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(left:8.0, top:8, right: 8.0),
        child: CustomScrollView(
          
          slivers: [
            //SliverToBoxAdapter(child: Text('Cantidad de anuncios ${anuncios.length}')),
            SliverToBoxAdapter(
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon( 
                          semanaActual.isCurrentWeek ? FluentIcons.completed_solid : FluentIcons.erase_tool,
                        size: 30,
                        color: semanaActual.isCurrentWeek ? CupertinoColors.activeGreen : CupertinoColors.inactiveGray ,
                        ),
                  Text( semanaActual.titulo  ,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                  IconButton(icon: Icon(FluentIcons.edit), onPressed: () => mostrarDialogoEditarTituloSemana(context, widget.semana) )

                        
                ],
              ),),
            // 1. SERVIDORES DE LA SEMANA Y ANUNCIOS
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: anuncios.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono dentro de un contenedor sutil estilo Fluent
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: FluentTheme.of(context).accentColor.normal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FluentIcons.megaphone,
                                size: 40,
                                color: FluentTheme.of(context).accentColor.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Texto de estado vacío más estilizado
                            Text(
                              'No hay anuncios para esta semana',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Botón Nativo Fluent UI
                            SizedBox(
                              width: 220,
                              child: FilledButton(
                                onPressed: () {
                                  privilegiosProvider.agregarPrivilegio(
                                    Privilege(
                                      weekId: widget.weekId,
                                      order: 0,
                                      type: null,
                                      isAnnouncement: true,
                                    )
                                  );
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
                          ],
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                    child: AnnouncementCardWidget(
                              weekId: widget.weekId,
                              listaAnuncios: anuncios,
                              //anuncio: _anuncios[index], // Pasamos solo el elemento actual
                              opciones: _opciones,
                    ),
                  )
            ),
                        
                        
                        
                      
                    
            

            // 2. LISTA DE PROGRAMAS
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: 
                (_cultos.isEmpty)
                ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono dentro de un contenedor sutil estilo Fluent
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: FluentTheme.of(context).accentColor.normal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FluentIcons.page_list,
                                size: 40,
                                color: FluentTheme.of(context).accentColor.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Texto de estado vacío más estilizado
                            Text(
                              'No hay programas agendados',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            
                          ],
                        ),
                      ),
                    )
                : SliverList( 
                
                  delegate: SliverChildBuilderDelegate (
                    childCount: _cultos.length,
                    (context, index) {
                      final culto = _cultos[index]; 
                      final privilegios = privilegiosProvider.privilegios.where(
                        (item) => ( item.weekId == widget.weekId) && ( item.serviceId == culto.id )
                      ) .toList()
                      ..sort((a, b) => (a.order ).compareTo(b.order));

                      return WorshipServiceCardWidget(
                        culto: culto,
                        
                        privilegios: privilegios,
                        opciones: _opciones
                      );
                    }
                  )
                ),
            ),





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
                      mostrarDialogoNuevoPrograma(context, _cultos.length, widget.weekId);
                    }
                  ),
                  
                ],
              ),
            ),





            // ULTIMO ESPACIO EN LA PARTE INFERIOR
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

