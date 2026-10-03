
import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/functions/confirmDialog_funtion.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:ad_galaad_app/widgets/privilegeCard_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class AnnouncementCardWidget extends StatefulWidget {
  final String weekId;
  final List<Privilege> _listaAnuncios;
  
  const new({
    super.key,
    required this.weekId,
    required this._listaAnuncios,
    
    required this._opciones,
  });

  final List<AutoSuggestBoxItem <String>> _opciones;

  @override
  State<AnnouncementCardWidget> createState() => _AnnouncementCardWidgetState();
}

class _AnnouncementCardWidgetState extends State<AnnouncementCardWidget> {



  @override
  Widget build(BuildContext context) {



    return material.Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)
      ),
      color: CupertinoColors.activeBlue.withOpacity(0.1),
      margin: EdgeInsets.only(bottom: 24, top: 8.0),
      child: Column(
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
                      Text('SERVIDORES DE LA SEMANA',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Servidores y anuncios de la semana',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                      ),
                    ],
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
                    )
                  ],
                ),
              
                
                //onPressed: () {},
              ),
          

          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget._listaAnuncios.length,
            // Desactiva el icono de arrastre por defecto de Flutter para usar el nuestro al final
            buildDefaultDragHandles: false, 
            onReorder: (oldIndex, newIndex) async {
              

              
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }


                // 1. Reordenar el elemento en la lista local
                final item = widget._listaAnuncios.removeAt(oldIndex);
                widget._listaAnuncios.insert(newIndex, item);

                // 2. Asignar el nuevo valor de 'order' a cada objeto en la lista
                for (int i = 0; i < widget._listaAnuncios.length; i++) {
                  widget._listaAnuncios[i] = widget._listaAnuncios[i].copyWith(order: i);
                }

                // 3. Notificar y guardar todos los cambios de una sola vez
                await context
                    .read<LocalPrivilegeStorageProvider>()
                    .actualizarOrdenesPrivilegios(widget._listaAnuncios);

                // 4. Rediseñar la vista para reflejar el nuevo orden en pantalla
                if (mounted) {
                  setState(() {});
                }

            },
            itemBuilder: (context, index) {
              final item = widget._listaAnuncios[index];

              return Column(
                // La Key es OBLIGATORIA para los hijos de un ReorderableListView
                key: ValueKey(item.id),
                children: [
                  PrivilegeCardWidget(
                    index: item.order,
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

widget._listaAnuncios.removeWhere((p) => p.id == item.id);
                      await context
                        .read<LocalPrivilegeStorageProvider>()
                        .actualizarOrdenesPrivilegios(widget._listaAnuncios);


                      }
                      
                      
                      
                      
                    },
                  ),
                  // Simulación de la línea divisoria (Divider) entre elementos
                  if (index < widget._listaAnuncios.length - 1)
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

          

          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: SizedBox(
              width: 250,
              child: Button(
                
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.0,
                  children: [
                    Icon(CupertinoIcons.add, color: CupertinoColors.activeGreen,),
                    Text('Agregar anuncio',
                      style: TextStyle(
                        color: CupertinoColors.activeGreen
                      ),
                    ),
                  ],
                ),
                onPressed: (){
                  context.read<LocalPrivilegeStorageProvider>().agregarPrivilegio(
                    Privilege(
                      weekId: widget.weekId,
                      type: null,
                      isAnnouncement: true,
                      order: widget._listaAnuncios.length
                    )
                  );
                }
              ),
            ),
          ),

          




          SizedBox(height: 8.0,),
    
    
        ],
      ),
    );
  }
}


