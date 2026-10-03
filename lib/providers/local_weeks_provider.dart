
import 'dart:convert';
import 'package:ad_galaad_app/classes/weeks_class.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';


class LocalWeeksStorageProvider extends ChangeNotifier{
  static const String _keySemanas = 'semanas_locales_v1';

  List<WeeklySchedule> _semanas = [];
  bool _cargando = false;

  List<WeeklySchedule> get semanas => _semanas;
  bool get cargando => _cargando;




  LocalWeeksStorageProvider() {
    cargarSemanasLocales(); // Carga automática al instanciar
  }

  // 1. CARGAR DATOS DEL DISCO LOCAL
  Future<void> cargarSemanasLocales() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_keySemanas)) {
        final String? usuariosJson = prefs.getString(_keySemanas);

        if (usuariosJson != null && usuariosJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(usuariosJson);
          _semanas = decodedList
              .map((item) => WeeklySchedule.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }  
        debugPrint('Semanas recuperados con éxito: ${_semanas.length}');
      } else {
        debugPrint('No se encontraron semanas previas en el almacenamiento local.');
        _semanas = []; // O la lista por defecto
      }
    } catch (e) {
      debugPrint('Error al cargar las semanas de cultos locales: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // 2. GUARDAR / AGREGAR USUARIO LOCAL
  Future<void> agregarSemana(WeeklySchedule nuevaSemana) async {
    // Generar un ID local basado en timestamp si no tiene uno
    final semanaConId = nuevaSemana.weekId == null || nuevaSemana.weekId!.isEmpty
        ? nuevaSemana.copyWith (
            weekId: DateTime.now().millisecondsSinceEpoch.toString(), // si no tiene ID o createdAt se lo agregamos
          )
        : nuevaSemana;

    _semanas.add(semanaConId);
    await _guardarEnDisco();
    notifyListeners();
  }


  Future<void> actualizarSemana( WeeklySchedule semanaActualizada) async {
    if (semanaActualizada.weekId == null || semanaActualizada.weekId!.isEmpty) return;

    // Buscamos el índice del culto que coincide con el ID
    final index = _semanas.indexWhere((c) => c.weekId == semanaActualizada.weekId);

    if (index != -1) {
      // Si existe, reemplazamos el elemento actualizando su marca de tiempo o weekId si fuera necesario
      _semanas[index] = semanaActualizada;

      debugPrint('Semana actualizada en posición $index con ID: ${semanaActualizada.weekId}');

      // Guardamos la lista modificada en el disco
      await _guardarEnDisco();

      // Notificamos a las pantallas/widgets suscritos para que redibujen
      notifyListeners();
    } else {
      debugPrint('No se encontró la semana a actualizar con ID: ${semanaActualizada.weekId}');
    }

  }



  // 4. ELIMINAR USUARIO
  Future<void> eliminarSemana(String? id) async {
    if (id == null) return;
    _semanas.removeWhere((u) => u.weekId == id);
    await _guardarEnDisco();
    notifyListeners();
  }

  // MÉTODOS PRIVADOS DE PERSISTENCIA
  Future<void> _guardarEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mapList =
        _semanas.map((u) => u.toMap()).toList();
    final String jsonString = jsonEncode(mapList);
    
    await prefs.setString(_keySemanas, jsonString);
  }


  // MANEJO DE LA ELIMINACIÓN EN CASCADA DE UNA SEMANA COMPLETA DE PROGRAMAS
  Future<void> eliminarSemanaCompleta(BuildContext context, String? weekId) async {
    // 1. Borrar privilegios vinculados a la semana
    await context.read<LocalPrivilegeStorageProvider >().eliminarPrivilegiosPorWeekId(weekId);

    // 2. Borrar servicios/cultos vinculados a la semana
    await context.read<LocalWorshipServicesProvider >().eliminarCultosPorWeekId(weekId);

    // 3. Finalmente, borrar la semana
    await eliminarSemana(weekId);
  }




}