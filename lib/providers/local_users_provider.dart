import 'dart:convert';

import 'package:ad_galaad_app/classes/user_class.dart';
import 'package:fluent_ui/fluent_ui.dart';
//import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageProvider extends ChangeNotifier{
  static const String _keyUsuarios = 'usuarios_locales_v1';

  List<UsuarioApp> _usuarios = [];
  bool _cargando = false;

  List<UsuarioApp> get usuarios => _usuarios;
  bool get cargando => _cargando;


  LocalStorageProvider() {
    cargarUsuariosLocales(); // Carga automática al instanciar
  }

  // 1. CARGAR DATOS DEL DISCO LOCAL
  Future<void> cargarUsuariosLocales() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_keyUsuarios)) {
        final String? usuariosJson = prefs.getString(_keyUsuarios);

        if (usuariosJson != null && usuariosJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(usuariosJson);
          _usuarios = decodedList
              .map((item) => UsuarioApp.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }  
        debugPrint('Usuarios recuperados con éxito: ${_usuarios.length}');
    } else {
      debugPrint('No se encontraron usuarios previos en el almacenamiento local.');
      _usuarios = []; // O la lista por defecto
    }
    } catch (e) {
      debugPrint('Error al cargar usuarios locales: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // 2. GUARDAR / AGREGAR USUARIO LOCAL
  Future<void> agregarUsuario(UsuarioApp nuevoUsuario) async {
    // Generar un ID local basado en timestamp si no tiene uno
    final usuarioConId = nuevoUsuario.id == null || nuevoUsuario.id!.isEmpty
        ? nuevoUsuario.copyWith (
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
          )
        : nuevoUsuario;

    _usuarios.add(usuarioConId);
    await _guardarEnDisco();
    notifyListeners();
  }

  /*
  // 3. ACTUALIZAR USUARIO EXISTENTE
  Future<void> actualizarUsuario(UsuarioApp usuarioActualizado) async {
    final index = _usuarios.indexWhere((u) => u.id == usuarioActualizado.id);
    if (index != -1) {
      _usuarios[index] = usuarioActualizado;
      
      if (_usuarioSeleccionado?.id == usuarioActualizado.id) {
        _usuarioSeleccionado = usuarioActualizado;
      }

      await _guardarEnDisco();
      notifyListeners();
    }
  }
  */

  // 4. ELIMINAR USUARIO
  Future<void> eliminarUsuario(String? id) async {
    if (id == null) return;

    _usuarios.removeWhere((u) => u.id == id);
    /*
    if (_usuarioSeleccionado?.id == id) {
      _usuarioSeleccionado = null;
    }*/
    await _guardarEnDisco();
    notifyListeners();
  }

  // MÉTODOS PRIVADOS DE PERSISTENCIA
  Future<void> _guardarEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mapList =
        _usuarios.map((u) => u.toMap()).toList();
    final String jsonString = jsonEncode(mapList);
    
    await prefs.setString(_keyUsuarios, jsonString);
  }




}