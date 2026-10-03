import 'package:flutter/material.dart';

class TextBtnClickeable extends StatefulWidget {
  final String texto;
  final VoidCallback onTap;
  final bool useEfect;

  const TextBtnClickeable({
    super.key,
    this.useEfect = false,
    required this.texto,
    required this.onTap,
  });

  @override
  State<TextBtnClickeable> createState() => _TextBtnClickeableState();
}

class _TextBtnClickeableState extends State<TextBtnClickeable> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta el click en el texto
      onTap: widget.onTap,
      child: MouseRegion(
        // Cambia el puntero al icono de la mano/click
        cursor: widget.useEfect ? SystemMouseCursors.click : SystemMouseCursors.alias,
        // Detecta el hover
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Text(
          widget.texto,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            // Cambia de color cuando el mouse pasa por encima
            color: widget.useEfect
              ?_isHovered ? Colors.white : Colors.white.withOpacity(0.3)
              : Colors.white,
          ),
        ),
      ),
    );
  }
}