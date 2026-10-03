
import 'package:ad_galaad_app/classes/weeks_class.dart';
import 'package:ad_galaad_app/providers/local_weeks_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

void mostrarDialogoEditarTituloSemana(BuildContext context, WeeklySchedule semana ){
  final titleController = TextEditingController(text: semana.titulo );

  showDialog(
    context: context, 
    builder: (contextDialog){
      return ContentDialog(
        title: const Text('Editar el titulo de esta semana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBox(
              controller: titleController,
              autofocus: true,
              maxLines: null,
            )
          ],
        ),
        actions: [
          Button(child: const Text('Cancelar'), onPressed: () => Navigator.pop(contextDialog)),
          FilledButton(
            child: const Text('Guardar'), 
            onPressed: () async {
              context.read<LocalWeeksStorageProvider>().actualizarSemana(
                semana.copyWith(
                  titulo: titleController.text
                )
              );
              Navigator.pop(contextDialog);
            }
          )
        ],
      );
    }
  );

}