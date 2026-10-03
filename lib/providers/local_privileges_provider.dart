

import 'dart:convert';
import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:fluent_ui/fluent_ui.dart';
//import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';


class LocalPrivilegeStorageProvider extends ChangeNotifier{
  static const String _keyPrivilegios = 'privilegios_locales_v1';

  List<Privilege> _privilegios = [];
  bool _cargando = false;

  List<Privilege> get privilegios => _privilegios;
  bool get cargando => _cargando;




  LocalPrivilegeStorageProvider() {
    cargarPrivilegiosLocales(); // Carga automática al instanciar
  }

  // 1. CARGAR DATOS DEL DISCO LOCAL
  Future<void> cargarPrivilegiosLocales() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_keyPrivilegios)) {
        final String? privilegiosJson = prefs.getString(_keyPrivilegios);

        if (privilegiosJson != null && privilegiosJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(privilegiosJson);
          _privilegios = decodedList
              .map((item) => Privilege.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }  
        debugPrint('Privilegios recuperados con éxito: ${_privilegios.length}');
      } else {
        debugPrint('No se encontraron privilegios previos en el almacenamiento local.');
        _privilegios = []; // O la lista por defecto
      }
    } catch (e) {
      debugPrint('Error al cargar los privilegios locales: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> limpiarAnuncios() async{
    _privilegios = [];
    await _guardarEnDisco();
    notifyListeners();
  }

  // 2. GUARDAR / AGREGAR USUARIO LOCAL
  Future<void> agregarPrivilegio(Privilege privilegio) async {
    // Generar un ID local basado en timestamp si no tiene uno
    final privilegioConId = privilegio.id == null || privilegio.id!.isEmpty
        ? privilegio.copyWith (

            id: DateTime.now().millisecondsSinceEpoch.toString(), // si no tiene ID o createdAt se lo agregamos
            
          )
        : privilegio;

    _privilegios.add(privilegioConId);
    await _guardarEnDisco();
    notifyListeners();
  }

/////////////////////////////////////

  // 3. ACTUALIZAR CULTO EXISTENTE
  Future<void> actualizarPrivilegio(Privilege privilegioActualizado) async {
    if (privilegioActualizado.id == null || privilegioActualizado.id!.isEmpty) return;

    // Buscamos el índice del culto que coincide con el ID
    final index = privilegios.indexWhere((c) => c.id == privilegioActualizado.id);

    if (index != -1) {
      // Si existe, reemplazamos el elemento actualizando su marca de tiempo o weekId si fuera necesario
      _privilegios[index] = privilegioActualizado;

      debugPrint('Privilegio actualizado en posición $index con ID: ${privilegioActualizado.id}');

      // Guardamos la lista modificada en el disco
      await _guardarEnDisco();

      // Notificamos a las pantallas/widgets suscritos para que redibujen
      notifyListeners();
    } else {
      debugPrint('No se encontró el culto a actualizar con ID: ${privilegioActualizado.id}');
    }
  }
   ///////////////////
   ///
  // En local_privileges_provider.dart
  Future<void> actualizarOrdenesPrivilegios(List<Privilege> listaActualizada) async {
    for (int i = 0; i < listaActualizada.length; i++) {
      final item = listaActualizada[i];
      final index = _privilegios.indexWhere((p) => p.id == item.id);
      if (index != -1) {
        _privilegios[index] = item.copyWith(order: i);
      }
    }
    await _guardarEnDisco();
    notifyListeners();
  }



  // 4. ELIMINAR USUARIO
  Future<void> eliminarPrivilegio(String? id) async {
    if (id == null) return;
    _privilegios.removeWhere((u) => u.id == id);
    await _guardarEnDisco();
    notifyListeners();
  }

  // MÉTODOS PRIVADOS DE PERSISTENCIA
  Future<void> _guardarEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mapList =
        _privilegios.map((u) => u.toMap()).toList();
    final String jsonString = jsonEncode(mapList);
    debugPrint('A punto de guardar en Disco');
    await prefs.setString(_keyPrivilegios, jsonString);
  }


  // METODOS PARA LA ELIMINACION EN CASCADA
  Future<void> eliminarPrivilegiosPorCultoId(String? cultoId) async {
    _privilegios.removeWhere((p) => p.serviceId == cultoId );
    await _guardarEnDisco();
    notifyListeners();
  }

  // METOODO UTIL PARA CUANDO SE ELIMINE UNA SEMANA
  Future<void> eliminarPrivilegiosPorWeekId(String? weekId) async {
    _privilegios.removeWhere((p) => p.weekId == weekId);
    await _guardarEnDisco();
    notifyListeners();
  }


  // En tu LocalPrivilegeStorageProvider
Future<void> agregarListaDePrivilegios(List<Privilege> nuevosPrivilegios) async {
  _privilegios.addAll(nuevosPrivilegios);
  notifyListeners(); // Una sola notificación para toda la lista
  await _guardarEnDisco(); // Una sola escritura en disco
}




}