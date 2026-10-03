

import 'dart:convert';


import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalConstantsProvider extends ChangeNotifier{
  static const String _keyConstantesLocales = 'constantes_locales_v1';

  bool _cargando = false;

  List<WorshipServiceFormat> _formatosCultos = [];
  //WeeklySchedule _semana = WeeklySchedule( weekId: 'semanaDeFormatos', isCurrentWeek: false, announcements: [],  programs: [], titulo: 'Formatos de programas');

  List<WorshipServiceFormat> get formatos => _formatosCultos;

  bool get cargando => _cargando;
  
  LocalConstantsProvider(){
    cargarConstantesLocales();
  }


  Future<void> cargarConstantesLocales() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if ( prefs.containsKey(_keyConstantesLocales)) {
        final String? constantesJson = prefs.getString(_keyConstantesLocales);
        if ( constantesJson != null && constantesJson.isNotEmpty) {
          final List<dynamic> decodeList = jsonDecode(constantesJson);
          _formatosCultos = decodeList
          .map((item) => WorshipServiceFormat.fromMap( Map<String, dynamic>.from(item)))
          .toList();
        }
        debugPrint('Constantes recuperadas con écito: ${_formatosCultos.length}');
      } else {
        debugPrint('No se encontraron constantes previos en el almacenamiento local.');
        _formatosCultos = [];
      }
      
    } catch (e) {
      debugPrint('Error al cargar las constantes locales: $e');
    } finally{
      _cargando = false;
      notifyListeners();
    }

  }

  Future<void> agregarFormato(WorshipServiceFormat nuevoFormato) async{
    final formatoConId = nuevoFormato.id == null || nuevoFormato.id!.isEmpty
      ? nuevoFormato.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      )
      : nuevoFormato;
    
    _formatosCultos.add(formatoConId);
    _guardarEnDisco();
    notifyListeners();
  }

  Future<void> actualizarFormato( WorshipServiceFormat formatoActualizado) async {
    if (formatoActualizado.id == null || formatoActualizado.id!.isEmpty) return;

    final index = _formatosCultos.indexWhere( (c) => c.id == formatoActualizado.id);

    if (index != -1) {

      _formatosCultos[index] = formatoActualizado;

      debugPrint('Formato de culto actualizado $index con ID: ${formatoActualizado.id}');

      await _guardarEnDisco();

      notifyListeners();
      
    } else {
      debugPrint('No se encontró el formato de culto a actualizar con ID: ${formatoActualizado.id}');
    }


  }

  


  

  Future<void> eliminarFormato( String id) async {
    _guardarEnDisco();
    notifyListeners();
  }

  Future<void> _guardarEnDisco() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = _formatosCultos.map( (u) => u.toMap()).toList();
      final String jsonString = jsonEncode(mapList);

      await prefs.setString(_keyConstantesLocales, jsonString);
      
    } catch (e) {
      debugPrint('Ha ocurrido un error al intentar guardar en disco $e');
    }
  }

  // Dentro de LocalConstantsProvider
Future<void> reordenarFormatos(List<WorshipServiceFormat> nuevaLista) async {
  // Reasignamos el índice de orden a cada formato si usas un campo 'order'
  for (int i = 0; i < nuevaLista.length; i++) {
    nuevaLista[i] = nuevaLista[i].copyWith(order: i);
  }

  _formatosCultos = nuevaLista;
  notifyListeners();

  // Guardamos la nueva lista serializada en SharedPreferences
  await _guardarEnDisco();
}


  


}