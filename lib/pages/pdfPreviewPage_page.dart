import 'dart:typed_data';
import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';
import 'package:ad_galaad_app/widgets/pdf_widgets.dart';
import 'package:ad_galaad_app/widgets/textBtnClickable_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PdfViewerPage extends StatefulWidget {
  final String title;
  final String tituloSemana;
  final List<Privilege> _privilegios;
  final List<WorshipService> _cultos;
  final List<Privilege> _anuncios;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.tituloSemana,
    required this._privilegios,
    required this._cultos,
    required this._anuncios
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  
  int _paginaActual = 1;
  int _totalPaginas = 1;




  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      
      header: PageHeader(
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

             Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.0,
              children: [
                TextBtnClickeable (texto: 'Programas de cultos', onTap: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          useEfect: true,),

             Icon(CupertinoIcons.forward, size: 18, color: Colors.white.withOpacity(0.3),),

           TextBtnClickeable(texto: widget.tituloSemana, useEfect: true, onTap: (){
            Navigator.of(context).pop();

           }),

           Icon(CupertinoIcons.forward, size: 18, color: Colors.white.withOpacity(0.3),),

           TextBtnClickeable(texto: 'Vista PDF', onTap: (){}),




              ],
            ),


           Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- BOTONES DE ZOOM ---
                  /*
                  IconButton(
                    icon: const Icon( CupertinoIcons.zoom_out , size: 14),
                    onPressed: _zoomScale > 0.6
                        ? () => setState(() => _zoomScale -= 0.15)
                        : null,
                  ),
                  Text(
                    '${(_zoomScale * 100).round()}%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: const Icon( CupertinoIcons.zoom_in , size: 14),
                    onPressed: _zoomScale < 1.8
                        ? () => setState(() => _zoomScale += 0.15)
                        : null,
                  ),
                  */

                  

                  // --- NAVEGACIÓN ENTRE PÁGINAS ---
                  IconButton(
  icon: Row(
    spacing: 12.0,
    children: [
      const Icon(FluentIcons.pdf, size: 16),
      const Text('Generar PDF')
    ],
  ),
  onPressed: () async {
    // 1. Genera los bytes del PDF
    final bytes = await _generarDocumentoPdf(PdfPageFormat.a4);

    // 2. Abre la ventana nativa de explorador ("Guardar como...")
    String? rutaGuardado = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar programa PDF',
      fileName: '${widget.title.replaceAll(' ', '_')}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    // 3. Si el usuario eligió una ruta y dio clic en "Guardar"
    if (rutaGuardado != null) {
      // Garantizar que la ruta siempre termine en .pdf (incluso si el usuario borró la extensión)
      if (!rutaGuardado.toLowerCase().endsWith('.pdf')) {
        rutaGuardado = '$rutaGuardado.pdf';
      }
      final archivo = File(rutaGuardado);
      await archivo.writeAsBytes(bytes);

      if (context.mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return const InfoBar(
              title: Text('Archivo guardado'),
              content: Text('El PDF se guardó correctamente en tu equipo.'),
              severity: InfoBarSeverity.success,
            );
          },
        );
      }
    }
  },
),

/*
const SizedBox(width: 8),
                  Container(height: 16, width: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(width: 8),
                  */
/*
IconButton(
  icon: const Icon(FluentIcons.print, size: 16),
  onPressed: () async {
    final bytes = await _generarDocumentoPdf(PdfPageFormat.a4);

    // 1. Obtener la cantidad de páginas usando Printing.raster
    final pageStream = Printing.raster(bytes);
    final totalPaginas = await pageStream.length;

    // 2. Abrir la ventana de selección de ruta
    String? rutaGuardado = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar programa PDF',
      fileName: '${widget.tituloSemana.replaceAll(' ', '_')}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (rutaGuardado != null) {
      // Garantizar la extensión .pdf
      if (!rutaGuardado.toLowerCase().endsWith('.pdf')) {
        rutaGuardado = '$rutaGuardado.pdf';
      }

      final archivo = File(rutaGuardado);
      await archivo.writeAsBytes(bytes);

      if (context.mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Archivo guardado'),
              content: Text(
                'El PDF de $totalPaginas página(s) se ha guardado correctamente.',
              ),
              severity: InfoBarSeverity.success,
            );
          },
        );
      }
    }
  },
),
*/

/*
                  IconButton(
  icon: const Icon(FluentIcons.print, size: 16),
  onPressed: () async {
    final bytes = await _generarDocumentoPdf(PdfPageFormat.a4);

    // Usar FilePicker directamente
    final String? rutaGuardado = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar programa PDF',
      fileName: '${widget.title.replaceAll(' ', '_')}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (rutaGuardado != null) {
      final archivo = File(rutaGuardado);
      await archivo.writeAsBytes(bytes);

      if (context.mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return const InfoBar(
              title: Text('Archivo guardado'),
              content: Text('El PDF se ha guardado correctamente en tu equipo.'),
              severity: InfoBarSeverity.success,
            );
          },
        );
      }
    }
  },
),
*/


const SizedBox(width: 8),
                  Container(height: 16, width: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(width: 8),


                  IconButton(
                    icon: const Icon(FluentIcons.chevron_left, size: 12),
                    onPressed: _paginaActual > 1
                        ? () => setState(() => _paginaActual--)
                        : null,
                  ),
                  Text(
                    'Página $_paginaActual de $_totalPaginas',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(FluentIcons.chevron_right, size: 12),
                    onPressed: _paginaActual < _totalPaginas
                        ? () => setState(() => _paginaActual++)
                        : null,
                  ),
                ],
              ),
            ),

            

            
          ],
        ),
      ),
      content: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            // Evita que la rueda del mouse haga zoom no deseado
          }
        },
        child: PdfPreview(
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          enableScrollToPage: true,
          allowPrinting: true,
          allowSharing: true,
          useActions: false,
          
          // Muestra solo la página actual seleccionada
          pages: [_paginaActual - 1],
        
          pdfFileName: '${widget.title.replaceAll(' ', '_')}.pdf',
          scrollViewDecoration: BoxDecoration(
            color: FluentTheme.of(context).inactiveBackgroundColor,
          ),
          pdfPreviewPageDecoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        
          // Calcula dinámicamente las páginas del PDF generado
          build: (format) async {
          final bytes = await _generarDocumentoPdf(format);
        
          // Contamos las páginas de forma segura usando Printing.raster
          try {
            final pageStream = Printing.raster(bytes);
            final count = await pageStream.length;
        
            if (mounted && _totalPaginas != count && count > 0) {
              setState(() {
                _totalPaginas = count;
              });
            }
          } catch (e) {
            debugPrint('Error al contar páginas del PDF: $e');
          }
        
          return bytes;
        },
        ),
      ),
    );
  }

  Future<Uint8List> _generarDocumentoPdf(PdfPageFormat format) async {
    final pdf = pw.Document();


      final fontRegular = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();
      final fontItalic = await PdfGoogleFonts.robotoItalic();
    

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(
          horizontal: 24.0, // Margen izquierdo y derecho
          vertical: 16.0,   // Margen superior e inferior
        ),
        build: (pw.Context context) {
          return  [
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    widget.title,
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ]
              ),
              pw.SizedBox(height: 12.0),
pw.Wrap(children: [
              buildPdfCard (
                title: 'Servidores de la semana',
                subtitle: 'Servidores y anuncios de la semana',
                privilegios: widget._anuncios,
                fontBold: fontBold,
                fontRegular: fontRegular,
                fontItalic: fontItalic
              ),
          ]),

              ...List.generate(
                widget._cultos.length,
                 (index){
                  final cultoData = widget._cultos[index];
                  final privilegios = widget._privilegios.where( (p) => p.serviceId == cultoData.id ).toList()..sort((a, b) => (a.order).compareTo(b.order));

                  return pw.Wrap(children: [
                    buildPdfCard(
                    title: cultoData.type, 
                    //subtitle: subtitle, 
                    privilegios: privilegios,
                    programa: cultoData,
                    fontBold: fontBold,
                    fontRegular: fontRegular,
                    fontItalic: fontItalic
                  )]);
                 }
              )

              
            ];
          
        },
      ),
    );

    return await pdf.save();
  }
}


