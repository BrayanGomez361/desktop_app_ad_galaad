


import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

Future<material.TimeOfDay?> mostrarSelectorHora(BuildContext context, material.TimeOfDay initialTime) async {
  final Color surfaceColor = FluentTheme .of(context).micaBackgroundColor;

  return await material.showTimePicker(
    context: context, 
    initialTime: initialTime,
    initialEntryMode: material.TimePickerEntryMode.dial,
    builder: (context, child) {
      return material.Theme(
        data: material.ThemeData.dark().copyWith(
          colorScheme: material.ColorScheme.dark(
            surface: surfaceColor,
            onSurface: material.Colors.white,
          ),
          dialogBackgroundColor: surfaceColor,
        ),
        child: Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: false,
              
            ),
            child: child!
          ),
        )
        ,
      );
    },
  );

}