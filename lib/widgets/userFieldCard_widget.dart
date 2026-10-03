import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material; 


class UserFieldCardWidget extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final enabled;

  const UserFieldCardWidget({super.key,
    required this.title,
    required this.controller,
    required this.enabled
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: 0),
      leading: Icon(FluentIcons.contact),
      title: Row(
        
        spacing: 24,
        children: [
        
          Expanded(
            flex: 2,
            child: Text(
              title,
              
              style: TextStyle( fontWeight: FontWeight.normal,  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: material.TextField(
              controller: controller,
              enabled: enabled,
            )
          ),
          SizedBox(width: 1.0,)
        ],
      ),
      
        
    );
  }
}