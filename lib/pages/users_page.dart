import 'package:ad_galaad_app/functions/add_local_user_function.dart';
import 'package:ad_galaad_app/pages/user_info_page.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LocalStorageProvider>();

    // 1. Estado de carga inicial
    if (local.cargando) {
      return const Center(
        child: ProgressRing(),
      );
    }

    if (local.usuarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.group, size: 40.0),
            const SizedBox(height: 12),
            const Text(
              'No hay usuarios registrados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => mostrarDialogoNuevoUsuario(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.add_medium , size: 14),
                  SizedBox(width: 8),
                  Text('Agregar primer usuario'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ScaffoldPage(
      header: PageHeader(
        title: Text('Usuarios de la aplicación'),
        commandBar: FilledButton(
          onPressed: () => mostrarDialogoNuevoUsuario (context),
          child: const Row(
            spacing: 8.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.person_add_solid , size: 20),
              Text('Nuevo usuario'),
            ],
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: local.usuarios.length,
              itemBuilder: (context, index){
                final usuario = local.usuarios[index];
                //final estaSeleccionado =  local.usuarioSeleccionado?.id == usuario.id;
                
                return material.Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        margin: EdgeInsets.zero,
                        contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 12),
                        leading: CircleAvatar(),
                        title: Text(
                          usuario.name ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Row(
                          spacing: 12.0,
                          children: [

                            Text( usuario.id != null
                              ? usuario.id!
                              : 'Sin id de usuario'
                            ),
                            
                            Text( ( usuario.birthday != null)
                              ? DateFormat('dd mm yyyy').format( usuario.birthday! )
                              : 'Sin fecha de cumpleaños'
                            ),

                            Text(usuario.email),

                            Text( usuario.carne != null
                              ? usuario.carne.toString()
                              : 'Sin carné de usuario'
                            ),
                          ],
                        ),
                        trailing: const Icon(CupertinoIcons.chevron_forward),
                        onPressed: () {
                          // Navega dentro del área de contenido sin ocultar el menú lateral
                          //Navigator.of(context).push( CupertinoPageRoute(builder: (context) => const PantallaDetallePage(),),
                          Navigator.of(context).push( CupertinoPageRoute(builder: (context) => UserInfoPage( userId: usuario.id ,) ) );
                          
                        },
                      ),
                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
   
  }
}