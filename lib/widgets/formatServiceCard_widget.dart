

import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/functions/createWorshipServiceTypeForm_function.dart';


import 'package:ad_galaad_app/functions/worshipServicesFormatFunctions/showEditingFormatView_function.dart';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:intl/intl.dart';


class FormatServiceCard extends StatefulWidget {
  final WorshipServiceFormat formato;
  const FormatServiceCard({
    super.key,
    required this.formato,
  });

  @override
  State<FormatServiceCard> createState() => _FormatServiceCardState();
}

class _FormatServiceCardState extends State<FormatServiceCard> {

  final FlyoutController _flyoutController = FlyoutController();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Liberamos el controlador cuando el widget se destruya
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('hh:mm a').format(widget.formato.dateTime );



    return SizedBox(
      width: 410,
      
      child: Card(
        padding: EdgeInsets.zero,
        
        borderRadius: BorderRadius.circular(8),
        
        child: 
          Column(
            children: [

              Container(
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: widget.formato.color,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        
                        children:[
                        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                
                                child: Text(
                                  widget.formato.type,
                                  
                                  textAlign: TextAlign.center,
                                  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20 ),
                                ),
                                
                              ),
                              Text('${widget.formato.order}')
                            ],
                          ),
                        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hora de inicio: $hora',
                                
                                style: TextStyle( fontWeight: FontWeight.normal, fontSize: 14  ),
                              ),
                            ],
                          ),
                        
                          SizedBox(height: 4.0,)
                        ],
                      ),
                    ),
              
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
                                    leading: const Icon(FluentIcons.title ),
                                    text: const Text('Editar encabezado'),
                                    onPressed: () async{
                                      Flyout.of(contextFlyout).close(); // Cerrar el menú
                                      //mostrarDialogoCambiarTipoDeCulto(context, culto)
                                      mostrarDialogCrearEditarNuevoFormatoDePrograma( context, widget.formato, widget.formato.order);
                                    },
                                  ),
                                  MenuFlyoutItem(
                                    leading: const Icon( FluentIcons.list),
                                    text: const Text('Modificar privilegios'),
                                    onPressed: () async {
                                      Flyout.of(contextFlyout).close();
                                      
                                      final copia = widget.formato;
                                      mostrarPrivilegiosDeUnFormatoDelPrograma(contextFlyout, copia);
                                    },
                                  ),
              
                                  const MenuFlyoutSeparator(),
              
                                  
                                  MenuFlyoutItem(
                                    leading: Icon(
                                      FluentIcons.delete,
                                      color: Colors.red,
                                    ),
                                    text: Text(
                                      'Eliminar formato',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
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
              
                    SizedBox(width: 12,)
              
              
                  ],
                ),
              ),


            
        Expanded(
          child: Scrollbar (
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              //shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: widget.formato.privileges.length,
              itemBuilder: (BuildContext context, index) {
                final privilegio = widget.formato.privileges[index];
                return Row(
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
        ),
        

        ],
      ),
        
        
      
      )
    );
  }
}