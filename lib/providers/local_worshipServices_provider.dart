

import 'dart:convert';
import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';


class LocalWorshipServicesProvider extends ChangeNotifier{
  static const String _keyCultos = 'cultos_locales_v1';

  List<WorshipService> _cultos = [];
  

  bool _cargando = false;

  List<WorshipService> get cultos => _cultos;
  

  bool get cargando => _cargando;



  
  LocalWorshipServicesProvider() {
    cargarCultosLocales(); // Carga automática al instanciar
  }
  
  // 1. CARGAR DATOS DEL DISCO LOCAL
  Future<void> cargarCultosLocales() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_keyCultos)) {
        final String? cultosJson = prefs.getString(_keyCultos);

        if (cultosJson != null && cultosJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(cultosJson);
          _cultos = decodedList
              .map((item) => WorshipService.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }  
        debugPrint('Cultos recuperados con éxito: ${_cultos.length}');
      } else {
        debugPrint('No se encontraron cultos previos en el almacenamiento local.');
        _cultos = []; // O la lista por defecto
      }
    } catch (e) {
      debugPrint('Error al cargar los cultos locales: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
  
  Future<void> limpiarCultos() async{
    _cultos = [];
    // Ademas limpiar los privilegios asociados
    await _guardarEnDisco();
    notifyListeners();
  }
  
  // 2. GUARDAR / AGREGAR USUARIO LOCAL
  Future<void> agregarCulto(WorshipService culto) async {
    // Generar un ID local basado en timestamp si no tiene uno
    final cultoConId = culto.id == null || culto.id!.isEmpty
        ? culto.copyWith (

            id: DateTime.now().millisecondsSinceEpoch.toString(), // si no tiene ID o createdAt se lo agregamos
          )
        : culto;

    _cultos.add(cultoConId);
    
    await _guardarEnDisco();
    notifyListeners();
  }

  // 3. ACTUALIZAR CULTO EXISTENTE
  Future<void> actualizarCulto(WorshipService cultoActualizado) async {
    if (cultoActualizado.id == null || cultoActualizado.id!.isEmpty) return;

    // Buscamos el índice del culto que coincide con el ID
    final index = _cultos.indexWhere((c) => c.id == cultoActualizado.id);

    if (index != -1) {
      // Si existe, reemplazamos el elemento actualizando su marca de tiempo o weekId si fuera necesario
      _cultos[index] = cultoActualizado;

      debugPrint('Culto actualizado en posición $index con ID: ${cultoActualizado.id}');

      // Guardamos la lista modificada en el disco
      await _guardarEnDisco();

      // Notificamos a las pantallas/widgets suscritos para que redibujen
      notifyListeners();
    } else {
      debugPrint('No se encontró el culto a actualizar con ID: ${cultoActualizado.id}');
    }
  }
  


  // 4. ELIMINAR USUARIO
  Future<void> eliminarCulto(String? cultoId) async {
    if (cultoId == null) return;
    _cultos.removeWhere((u) => u.id == cultoId);
    await _guardarEnDisco();
    notifyListeners();
  }
  

  // MÉTODOS PRIVADOS DE PERSISTENCIA
  Future<void> _guardarEnDisco() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList =
      _cultos.map((u) => u.toMap()).toList();

      final String jsonString = jsonEncode(mapList);
      
      await prefs.setString(_keyCultos, jsonString);
      
    } catch (e) {
      debugPrint('Ha ocurrido un error al intentar guardar en disco $e');
    }
    
  }

  // METODOS PARA LA ELIMINACION EN CASCADA
  Future<void> eliminarCultoYPrivilegiosAsociados(BuildContext context, String? cultoId) async {
    // 1. Eliminando los privilegios asociados con el cultoId
    await context.read<LocalPrivilegeStorageProvider>().eliminarPrivilegiosPorCultoId(cultoId);

    debugPrint('Ya se eliminaron los privilegios asociados');
    // 2. Eliminando el culto por el id
    await eliminarCulto(cultoId);
  }

  Future<void> eliminarCultosPorWeekId(String? weekId) async {
    if (weekId == null) return;
    _cultos.removeWhere((c) => c.weekId == weekId);
    await _guardarEnDisco();
    notifyListeners();
  }


  




}