



import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/classes/weeks_class.dart';
import 'package:intl/intl.dart';


/// Utilidad:
/// Actualizar el titulo de la semana en base a las fechas del primer y ultimo
/// culto de esa semana
String actualizarTituloSemana( List<WorshipService> semana, WeeklySchedule actual ){
  if (semana.isEmpty) return actual.titulo;

  final f1 = semana.first.dateTime;
  final f2 = semana.last.dateTime;
  

  String titulo = 'Programas del ${f1.day} al ${f2.day} de ${DateFormat('MMMM','es').format(f2)} del ${f2.year}';
  if (f1.month != f2.month) {
    titulo = 'Programas del ${f1.day} de ${DateFormat('MMMM','es').format(f1)} al ${f2.day} de ${DateFormat('MMMM','es').format(f2)} del ${f2.year}';
  }


  return titulo;
}