
import 'package:fluent_ui/fluent_ui.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FlyoutController _flyoutController = FlyoutController();
  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    

    return ScaffoldPage(
      header: PageHeader(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Calendario de actividades'),
            FlyoutTarget(
              controller: _flyoutController, 
              child: IconButton(
                icon: const Icon(FluentIcons.more, size: 18),
                onPressed: (){
                  _flyoutController.showFlyout(
                    placementMode: FlyoutPlacementMode.bottomCenter,
                    builder: (contextFlyout) {
                      return MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            leading: const Icon(FluentIcons.add_event),
                            text: const Text('Crear evento'),
                            onPressed: () {
                              Flyout.of(contextFlyout).close();
                            },
                          ),
                          /*
                          MenuFlyoutItem(
                            leading: const Icon(FluentIcons.group),
                            text: const Text('Agrupar por categoría'),
                            onPressed: () {
                              Flyout.of(contextFlyout).close();
                            },
                          ),*/
                        ],
                      );
                    },
                  );
                }
              )
            ),
          ],
        ),
        
      ),
      content: CustomScrollView(
        slivers: [
          

          

            

            // 2. Estado vacío (Empty State) estilizado en caso de no tener actividades asignadas
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                        ),
                      ),
                      child: Icon(
                        FluentIcons.calendar_reply,
                        size: 42,
                        color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay actividades programadas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Haz clic en "Nueva actividad" para agregar eventos al calendario.',
                      style: TextStyle(
                        fontSize: 13,
                        color: FluentTheme.of(context).typography.body?.color?.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}