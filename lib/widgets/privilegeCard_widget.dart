


import 'package:ad_galaad_app/classes/privilege_class.dart';

import 'package:ad_galaad_app/functions/showFormEditPrivilege_function.dart';

import 'package:fluent_ui/fluent_ui.dart';


class PrivilegeCardWidget extends StatefulWidget {
  final int index;
  final Privilege privilegio;
  final List<AutoSuggestBoxItem <String>> _opciones;
  final VoidCallback onDelete;
  const new({
    super.key,
    required this.index,
    required this.privilegio,
    required this._opciones,
    required this.onDelete
  });

  

  @override
  State<PrivilegeCardWidget> createState() => _PrivilegeCardWidgetState();
}

class _PrivilegeCardWidgetState extends State<PrivilegeCardWidget> {

  late TextEditingController _tipoController;
  late TextEditingController _encargadoController;
  late TextEditingController _indicacionesController;

  @override
  void initState() {
    super.initState();
    _tipoController = TextEditingController(text: widget.privilegio.type);
    _encargadoController = TextEditingController(text: widget.privilegio.userId);
    _indicacionesController = TextEditingController(text: widget.privilegio.guidelines);
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _encargadoController.dispose();
    _indicacionesController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tipoController = TextEditingController(text: widget.privilegio.type);
    _encargadoController = TextEditingController(text: widget.privilegio.userId);
    _indicacionesController = TextEditingController(text: widget.privilegio.guidelines);

    return ListTile(
      
      contentPadding: EdgeInsets.only(top: 4.0, bottom: 4.0, left:8.0, right: 16.0),
      margin: EdgeInsets.only(top: 0.0),
      //leading: Icon(FluentIcons.contact, size: 15,),
      leading: Text('${widget.privilegio.order+1}', ),
      contentAlignment: CrossAxisAlignment.start,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Expanded(
            flex:2,
            child:  TextBox(
              controller: _tipoController,
                  //placeholder: 'Ej. Preside',
                  enabled: false,
                  maxLines: null,
                    onChanged: (value) {
                _tipoController.text = widget.privilegio.type ?? '';
              },   
                ),
            
          ),
          
          Expanded(
            flex: 2,
            child: TextBox(
              controller: _encargadoController,
              //placeholder: 'Buscar encargado...',
              //items: widget._opciones,
              enabled: false,
              maxLines: null,
              onChanged: (value) {
                _encargadoController.text = widget.privilegio.userId ?? '';
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: TextBox(
              controller: _indicacionesController,
              //placeholder: 'Indicaciones...',
              style: TextStyle(fontStyle: FontStyle.italic),
              enabled: false,
              maxLines: null,
                onChanged: (value) {
                _indicacionesController.text = widget.privilegio.guidelines ?? '';
              },    
            ),
          )
        ],
      ),

      trailing: Row(
        spacing: 8.0,
        children: [
          const SizedBox(width: 8.0,),

          
          
          Visibility(
            visible: true,
            child: Row(
              spacing: 8.0,
              children: [
                


                Tooltip (
                  message: 'Eliminar esta fila', // Texto que aparecerá en el globo
                  displayHorizontally: true, // Opcional: orientación del mensaje
                  useMousePosition: false,     // Opcional: sigue el cursor del mouse
                  child: Button(
                    /*style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(material.Colors.red),
                            ),*/
                    child: Icon(
                      FluentIcons.delete,
                    ),
                    onPressed: widget.onDelete, 
                    /*onPressed: () async {

                      final confirmar = await mostrarDialogoDeConfirmacion (
                        context: context, 
                        titulo: 'Eliminar privilegio', 
                        mensaje: '¿Estás seguro de que deseas eliminar este privilegio? Esta acción no se puede deshacer.'

                      );

                      if (confirmar && context.mounted) {
                        await context.read<LocalPrivilegeStorageProvider>().eliminarPrivilegio(widget.privilegio.id);
                      }
                      
                    }
                    */
                  ),
                ),

                Tooltip(
                  message: 'Editar la información de esta fila', // Texto que aparecerá en el globo
                  displayHorizontally: true, // Opcional: orientación del mensaje
                  useMousePosition: false,     // Opcional: sigue el cursor del mouse
                  child: Button(
                    /*style: ButtonStyle(
                              //backgroundColor: WidgetStateProperty.all(material.Colors.gray),
                            ),*/
                    child: Icon(
                      FluentIcons.edit,
                    ), 
                    onPressed: () => mostrarDialogoEditarPrivilegio(context, widget.privilegio , widget._opciones)
                  ),
                ),


              ],
            )
          ),
          

          /*
          Button(child: Icon(
              FluentIcons.global_nav_button, size: 12,), 
              onPressed: (){}
            ),*/
            ReorderableDragStartListener(
              index: widget.index,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Icon(
                    FluentIcons.global_nav_button,
                    size: 14,
                  ),
                ),
              ),
            ),

        ],
      ),
      
    );
  }
}