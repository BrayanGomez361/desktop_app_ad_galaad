import 'package:ad_galaad_app/classes/worship_formatService_type.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';
import 'package:ad_galaad_app/widgets/formatServiceCard_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalConstantsProvider>();
    final formatos = provider.formatos;

    return ScaffoldPage(
      header: PageHeader(
        title: Text('Formatos de Cultos ${formatos.length}'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('Nuevo Formato'),
              onPressed: () {},

            ),
          ],
        ),
      ),
      content: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: ReorderableSliverGridView(
              // Parámetros obligatorios de layout
              crossAxisCount: 3, // Número de columnas
              mainAxisSpacing: 12.0, // Espaciado vertical
              crossAxisSpacing: 12.0, // Espaciado horizontal
              childAspectRatio: 1.8, // Proporción Ancho / Alto de la tarjeta

              dragStartDelay: Duration.zero,

              // Callback de reordenamiento
              onReorder: (oldIndex, newIndex) {
                final listaActualizada = List<WorshipServiceFormat>.from(formatos);
                final item = listaActualizada.removeAt(oldIndex);
                listaActualizada.insert(newIndex, item);

                context.read<LocalConstantsProvider>().reordenarFormatos(listaActualizada);
              },

              // Generamos la lista de Widgets asignando a cada uno su Key
              children: formatos.map((formato) {
                return FormatServiceCard(
                  key: ValueKey(formato.id),
                  formato: formato,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}