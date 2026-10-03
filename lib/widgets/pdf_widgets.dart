import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';

import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;






// Definición de colores basados en la UI de tu imagen
const PdfColor darkCardBg = PdfColor.fromInt(0xFF1B232E); // Fondo contenedor azul oscuro
const PdfColor inputBg = PdfColor.fromInt(0xFF121820);    // Fondo estilo input
const PdfColor borderTone = PdfColor.fromInt(0xFF2C3847); // Borde sutil estilo Fluent UI
const PdfColor textMuted = PdfColor.fromInt(0xFF8D99A8);  // Texto secundario

extension ColorToPdfExtension on material.Color {
  /// Convierte un Color de Flutter a PdfColor usando el valor entero hexadecimal (ARGB)
  PdfColor toPdfColor() {
    return PdfColor.fromInt(value);
  }
}




/// 1. WIDGET CONTENEDOR TIPO CARD (Base reusable)
pw.Widget buildPdfCard({
  required String title,
  String? subtitle,
  required List<Privilege> privilegios,
  WorshipService? programa,
  required pw.Font fontBold,
  required pw.Font fontRegular,
  required pw.Font fontItalic,
}) {
  final PdfColor colorCulto = programa?.color.toPdfColor() ?? PdfColors.black ;
  String diaFormato = "";
  String horaFormato = "";

  if (programa != null) {
    // 1. Formateadores independientes
    diaFormato = DateFormat('EEEE d', 'es').format(programa.dateTime);
    horaFormato = DateFormat('hh:mm a', 'es').format(programa.dateTime);

    // 2. Armar el título combinando texto estático y dinámico
    //titulo = "$diaFormato | ${programa.type} | 'Hora:' $horaFormato";
  }

  //final iconFont = await PdfGoogleFonts.materialIcons();

  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 16.0),
    //padding: const pw.EdgeInsets.all(16.0),
    decoration: pw.BoxDecoration(
      //color: darkCardBg,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6.0)),
      border: pw.Border.all(color: colorCulto, width: 0.5),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Encabezado de la Card

        pw.Container(
          width: double.infinity, // Ocupa todo el ancho de la tarjeta
          padding: const pw.EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: pw.BoxDecoration(
            color: colorCulto, // <--- Únicamente aquí va el color de fondo
            borderRadius: pw.BorderRadius.only(
              topLeft: pw.Radius.circular(5.5),
              topRight: pw.Radius.circular(5.5),
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado cuando hay un Programa
              if (programa != null)
                pw.Row(
                  children: [
                    pw.Text(
                      diaFormato.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                        font: fontBold,
                      ),
                    ),
                    pw.SizedBox(
                      width: 12.0,
                      child: pw.Center(
                        child: pw.Text(
                          '|',
                          style: const pw.TextStyle(color: PdfColors.white),
                        ),
                      ),
                    ),
                    pw.Text(
                      programa.type,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: fontRegular,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(
                      width: 12.0,
                      child: pw.Center(
                        child: pw.Text(
                          '|',
                          style:  pw.TextStyle(color: PdfColors.white ),
                        ),
                      ),
                    ),
                    pw.Text(
                      'Hora: $horaFormato',
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: fontRegular,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),

              // Encabezado cuando no hay Programa (ej. Anuncios / Servidores)
              if (programa == null)
                pw.Text(
                  title.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: fontBold,
                    color: PdfColors.white,
                  ),
                ),

              // Subtítulo condicional
              if (subtitle != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  subtitle,
                  style: const pw.TextStyle(fontSize: 10, color: textMuted),
                ),
              ],
            ],
          ),
        ),




/*
        if(programa != null)
          pw.Row(
            
            children: [

              pw.Text(
                diaFormato.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  //fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  font: fontBold
                ),
              ),
              
              pw.SizedBox(
                width: 12.0,
                child: 
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      '|',
                     style: const pw.TextStyle(color: textMuted)
                    )
                  ]
                )
              ),

              pw.Text(
                programa.type,
                style: pw.TextStyle(
                  fontSize: 12,
                  //fontWeight: pw.FontWeight.normal,
                  font: fontRegular,
                  color: PdfColors.white,
                ),
              ),

              pw.SizedBox(
                width: 12.0,
                child: 
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      '|',
                     style: const pw.TextStyle(color: textMuted)
                    )
                  ]
                )
              ),


              pw.Text(
                'Hora: $horaFormato',
                style: pw.TextStyle(
                  fontSize: 12,
                  //fontWeight: pw.FontWeight.normal,
                  font: fontRegular,
                  color: PdfColors.white,
                ),
              ),



            ]
          ),
          

        if(programa == null)
          pw.Text(
            title.toUpperCase() ,
            style: pw.TextStyle(
              fontSize: 14,
              font: fontBold,
              //fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),


        //pw.SizedBox(height: 2),

        if(subtitle != null)
        pw.Text(
          subtitle,
          style: const pw.TextStyle(fontSize: 10, color: textMuted),
        ),
        pw.SizedBox(height: 8),
        */

        // 2. CUERPO DE LA TARJETA (Filas de privilegios sin color de fondo)
        pw.Padding(
          padding: const pw.EdgeInsets.all(12.0),
          child: pw.Column(
            children: [
              ...List.generate(privilegios.length, (index) {
                final item = privilegios[index];
                return pw.Column(
                  children: [
                    buildCustomRow(
                      privilegio: item.type ?? '',
                      encargado: item.userId ?? '',
                      indicaciones: item.guidelines ?? '',
                      fontBold: fontBold,
                      fontRegular: fontRegular,
                      fontItalic: fontItalic,
                    ),
                    if (index < privilegios.length - 1)
                      pw.Divider(
                        height: 6,
                        thickness: 0.5,
                        color: borderTone,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),

        // Encabezados de la Tabla / Fila (Privilegio | Encargado | Indicaciones)
        /*
        pw.Row(
          children: [
            pw.SizedBox(width: 20), // Espacio equivalente a la numeración
            pw.Expanded(
              flex: 2,
              child: pw.Center(
                child: pw.Text(
                  'Privilegio',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 3,
              child: pw.Center(
                child: pw.Text(
                  'Encargado del privilegio',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 3,
              child: pw.Center(
                child: pw.Text(
                  'Indicaciones sobre el privilegio',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                ),
              ),
            ),
          ],
        ),
        */
        //pw.SizedBox(height: 8),

        // Filas de privilegios
        //if(isAnnouncements)
        /*
        ...List.generate(privilegios.length, (index) {
          final item = privilegios[index];
          return pw.Column( 
            children: [ 
              buildCustomRow(
                //number: '${index + 1}',
                privilegio: item.type?? '',
                encargado: item.userId ?? '',
                indicaciones: item.guidelines ?? '',
                fontBold: fontBold,
                fontRegular: fontRegular,
                fontItalic: fontItalic
              ),
              if(index < privilegios.length-1)
              pw.Divider(
                height: 3,
                thickness: 0.5,
                color: textMuted
              )
          ],
          );
        }),
        */

        //if(!isAnnouncements)
        


      ],
    ),
  );
}

pw.Widget buildCustomRow({
  required String privilegio,
  required String encargado,
  required String indicaciones,
  required pw.Font fontBold,
  required pw.Font fontRegular,
  required pw.Font fontItalic,
}){
return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3.0),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        

        

        pw.Container(
          width: 12,
          height: 12,
          margin: const pw.EdgeInsets.only(right: 8.0),
          decoration: pw.BoxDecoration(
            //color: inputBg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2.0)),
            border: pw.Border.all(
              color: borderTone, 
              width: 0.8,
            ),
          ),
        ),

        pw.Expanded(
          child: pw.Wrap(
            crossAxisAlignment: pw.WrapCrossAlignment.start,
            runSpacing: 2.0, // Espaciado vertical si la indicación salta de línea
            spacing: 6.0,    // Espaciado horizontal entre elementos
            children: [
              // Privilegio + Encargado (pueden ir juntos o separados)
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    if (privilegio.isNotEmpty)
                      pw.TextSpan(
                        text: '$privilegio: ',
                        style: pw.TextStyle(
                          font: fontBold,
                          //color: PdfColors.white,
                          fontSize: 11,
                        ),
                      ),
                    pw.TextSpan(
                      text: encargado,
                      style: pw.TextStyle(
                        font: fontRegular,
                        //color: PdfColors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Indicaciones: Si caben se quedan a la par, si no, el Wrap las baja automáticamente
              if (indicaciones.isNotEmpty)
                pw.Text(
                  '($indicaciones)',
                  style: pw.TextStyle(
                    font: fontItalic,
                    //color: textMuted,
                    color: PdfColors.grey800,
                    fontSize: 10.0,
                  ),
                ),
            ],
          ),
        ),


      ],
    ),
  );
}
/// 2. FILA QUE SIMULA LOS INPUTS Y NUMERACIÓN
pw.Widget buildPdfRowInputSimulated({
  required String number,
  required String privilegio,
  required String encargado,
  required String indicaciones,
}) {

  

  

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3.0),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Número
        /*w.SizedBox(
          width: 20,
          child: pw.Text(
            number,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
          ),
        ),
        */

        //pw.Icon(  ) ,
        //pw.Checkbox(value: false, name: 'Hola'),
        
        
        // Campo 1: Privilegio
        pw.Expanded(
          flex: 2,
          child: buildFakeInputBox(privilegio),
        ),
        pw.SizedBox(width: 8),

        // Campo 2: Encargado
        pw.Expanded(
          flex: 3,
          child: buildFakeInputBox(encargado),
        ),
        pw.SizedBox(width: 8),

        // Campo 3: Indicaciones
        pw.Expanded(
          flex: 3,
          child: buildFakeInputBox(indicaciones),
        ),
      ],
    ),
  );
}

/// 3. CAJA QUE SIMULA EL TEXTFIELD DE FLUTTER
pw.Widget buildFakeInputBox(String text) {
  return pw.Container(
    height: 22,
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: pw.BoxDecoration(
      color: inputBg,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4.0)),
      border: pw.Border.all(color: borderTone, width: 0.5),
    ),
    child: pw.Align(
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.white),
        maxLines: 1,
        overflow: pw.TextOverflow.clip,
      ),
    ),
  );
}


