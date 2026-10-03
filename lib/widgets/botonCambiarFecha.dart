import 'package:fluent_ui/fluent_ui.dart';

class BotonCambiarFecha extends StatefulWidget {
  final DateTime? fechaInicial;
  final ValueChanged<DateTime>? onChanged;

  const BotonCambiarFecha({
    super.key,
    this.fechaInicial,
    this.onChanged
  });

  @override
  State<BotonCambiarFecha> createState() => _BotonCambiarFechaState();
}

class _BotonCambiarFechaState extends State<BotonCambiarFecha> {
  // Controller para gestionar el despliegue del Flyout
  final FlyoutController _flyoutController = FlyoutController();
  late DateTime _fechaSeleccionada;
  //DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = widget.fechaInicial ?? DateTime.now();
  }

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_fechaSeleccionada = widget.fechaInicial ?? DateTime.now();

    return FlyoutTarget(
      controller: _flyoutController,
      child: Button(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        onPressed: () {
          // Muestra el menú emergente justo en la posición del botón
          _flyoutController.showFlyout(
            autoModeConfiguration: FlyoutAutoConfiguration(
              preferredMode: FlyoutPlacementMode.bottomCenter,
            ),
            builder: (context) {
              return FlyoutContent(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment .start,
                    children: [
                      const Text(
                        'Seleccionar nueva fecha',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      
                      // Selector de Fecha Nativo de Fluent UI
                      DatePicker(
                        selected: _fechaSeleccionada,
                        onChanged: (newDate) {
                          setState(() {
                            //_fechaSeleccionada = value;
                            _fechaSeleccionada = DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              _fechaSeleccionada.hour,
                              _fechaSeleccionada.minute,
                            );
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),

                      // 2. Selector de Hora Nativo de Fluent UI
                      TimePicker(
                        selected: _fechaSeleccionada,
                        onChanged: (newTime) {
                          setState(() {
                            // Mantiene el día actual y actualiza hora y minutos
                            _fechaSeleccionada = DateTime(
                              _fechaSeleccionada.year,
                              _fechaSeleccionada.month,
                              _fechaSeleccionada.day,
                              newTime.hour,
                              newTime.minute,
                            );


                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton(
                            child: const Text('Guardar'),
                            onPressed: () {
                              if (widget.onChanged != null) {
                                widget.onChanged!(_fechaSeleccionada);
                              }
                              // Cierra el menú emergente
                              Navigator.of(context).pop();
                              
                              // Aquí puedes procesar la actualización
                              print('Fecha guardada: $_fechaSeleccionada');
                            },
                          ),
                          const SizedBox(width: 8),
                          Button(
                            child: const Text('Cancelar'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.calendar, size: 14),
            SizedBox(width: 8),
            Text('Cambiar fecha y hora'),
          ],
        ),
      ),
    );
  }
}