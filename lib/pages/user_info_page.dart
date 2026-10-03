import 'package:ad_galaad_app/classes/user_class.dart';
import 'package:ad_galaad_app/functions/confirmDeleteUser_functino.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:ad_galaad_app/widgets/userFieldCard_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class UserInfoPage extends StatefulWidget {
  final String? userId;
  const UserInfoPage({super.key, this.userId});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late final TextEditingController _idController;
  late final TextEditingController _createdAtController;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late final TextEditingController _birthdayController;
  late final TextEditingController _rolController;
  late final TextEditingController _carneController;
  

  bool esModoNuevoUsuario = false;
  bool _isEditing = false;
  UsuarioApp ? _usuarioActual;

  @override
  void initState() {
    super.initState();
    
    _idController = TextEditingController();
    _createdAtController  = TextEditingController();

    _nameController = TextEditingController();
    _emailController = TextEditingController();

    _birthdayController = TextEditingController();
    _rolController = TextEditingController();
    _carneController = TextEditingController();


    if (widget.userId == null) {
      esModoNuevoUsuario = true; 
    } else {
      // Isagana ti data ti usuario para iti visualisasion[cite: 1]
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cargarDatosUsuario();
      });
    }

    

  }

  void _cargarDatosUsuario() {
    final provider = context.read<LocalStorageProvider>();
    final usuario = provider.usuarios.firstWhere(
      (u) => u.id == widget.userId,
      orElse: () => UsuarioApp(name: '', email: ''),
    );

    setState(() {
      _usuarioActual = usuario;
      _idController.text = usuario.id ?? 'Sin id de usuario';
      _createdAtController.text = (usuario.createdAt != null) ? DateFormat("dd MMMM 'del 20'yy 'a las' hh:mm a", 'es').format(usuario.createdAt!) : '';
      _nameController.text = usuario.name;
      _emailController.text = usuario.email;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _createdAtController.dispose();

    _nameController.dispose();
    _emailController.dispose();

    _birthdayController.dispose();
    _rolController.dispose();
    _carneController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LocalStorageProvider>();

    if (local.cargando) {
      return const Center(
        child: ProgressRing(),
      );
    }

    

    return ScaffoldPage(
      
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(CupertinoIcons.back, size: 20, ), 
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            esModoNuevoUsuario 
                ? 'Configurar mi Perfil' 
                : 'Detalles del Usuario',
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(8.0),
        
        child: Row(
          children: [

            Expanded(
              child: CustomScrollView(
                slivers: [
              
                  SliverPadding(
                    padding: const EdgeInsets.only(right: 18, left: 10.0),
                    sliver: SliverList(
                      //padding: EdgeInsets.only(right: 18, left: 10.0),
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: CircleAvatar(
                            maxRadius: 60,
                          ),
                        ),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //spacing: 8.0,
                          children: [
                            if(!_isEditing)
                            Button(
                              child: Row(
                                spacing: 8.0,
                                children: [
                                  Icon(FluentIcons.edit),
                                  Text('Editar')
                                ],
                              ), onPressed: (){
                                setState(() {
                                  _isEditing = true;
                                });
                              }
                            ),
                    
                            Visibility(
                              visible: _isEditing,
                              child: Row(
                                spacing: 8.0,
                                children: [
                                  
                                  Button(
                                    child: Row(
                                      spacing: 8.0,
                                      children: [
                                        Icon(FluentIcons.check_mark),
                                        Text('Guardar')
                                      ],
                                    ), onPressed: (){}
                                  ),
                                  Button(
                                    child: Row(
                                      spacing: 8.0,
                                      children: [
                                        Icon(FluentIcons.cancel),
                                        Text('Cancelar')
                                      ],
                                    ), onPressed: (){
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    }
                                  ),
                                ],
                              )
                            ),
                            
                          ],
                        ),
              
                        material.Card(
                          child: Column(
                            children: [
                              UserFieldCardWidget(title: 'Identificador de Usuario', controller: _idController, enabled: false),
                              UserFieldCardWidget(title: 'Fecha de creación de la cuenta', controller: _createdAtController, enabled: false),
                              UserFieldCardWidget(title: 'Nombre de usuario', controller: _nameController, enabled: _isEditing),
                              UserFieldCardWidget(title: 'Correo electrónico', controller: _emailController, enabled: false),
                              UserFieldCardWidget(title: 'Fecha de nacimiento', controller: _birthdayController, enabled: _isEditing),
                              UserFieldCardWidget(title: 'Rol del usuario', controller: _rolController, enabled: false),
                              UserFieldCardWidget(title: 'Carné', controller: _carneController, enabled: false),
                            ],
                          ),
                        ),
                        
                    
                        SizedBox(height: 25,),
                        
                      ],
                    )
                    
                    ),
                  ),
              
                  //if(esModoNuevoUsuario)
                  SliverFillRemaining(
                    hasScrollBody: false, // Evita scroll interno
                    child: Container(
                      padding: const EdgeInsets.only( bottom: 25.0),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          
                          CupertinoButton.tinted(
                            color: CupertinoColors.systemRed,
                            child: Row(
                              spacing: 12.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.delete, color: CupertinoColors.white,),
                                Text('Eliminar usuario', style: TextStyle(color: CupertinoColors.white),),
                              ],
                            ), onPressed:() => confirmarEliminacionUsuarioLocal(context, _usuarioActual )                        
                              
                            ),
                          
                        ],
                      ),
                    ),
                  ),
              
                ],
              ),
            ),

            //SizedBox(width: 18,child: Divider( direction: Axis.vertical,)),

            Expanded(
              
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(right: 18, left: 10.0),
                    sliver: SliverList(
                      
                      delegate: SliverChildListDelegate([
                    
                        material.Card(
                          child: Column(
                            children: [
                              ListTile(title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Directiva 1'),
                                ],
                              ),),
                              ListTile(title: Text('data'),  ),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                            ],
                          ),
                        ),
                    
                        material.Card(
                          child: Column(
                            children: [
                              ListTile(title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Directiva 1'),
                                ],
                              ),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                            ],
                          ),
                        ),
                    
                        material.Card(
                          child: Column(
                            children: [
                              ListTile(title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Directiva 1'),
                                ],
                              ),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                              ListTile(title: Text('data'),),
                            ],
                          ),
                        ),
                    
                        
                    
                        
                        
                      ],)
                    ),
                  ),
                ],
              )
            ),
            SizedBox(
              width: 18,
              //child: Divider( direction: Axis.vertical,)
            ),

          ],
        ),
      ),
    );
  }
}