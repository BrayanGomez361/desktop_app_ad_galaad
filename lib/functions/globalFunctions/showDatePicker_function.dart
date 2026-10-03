


import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

Future<DateTime?> mostrarDatePicker( BuildContext context, DateTime initial) async {
  
  final Color surfaceColor = FluentTheme.of(context).micaBackgroundColor;

  return await material.showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (context, child) {
      return material.Theme (
          data: material.ThemeData.dark().copyWith(
            colorScheme: material.ColorScheme.dark(
              surface: surfaceColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: surfaceColor,
          ),
          child: child!,
        );
    },
  );


}