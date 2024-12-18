import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message, required this.color});

  final String name;
  final String message;
  final String color;

  
  Color strColor() {
    if (colorFromHex(color) != null) {
      return colorFromHex(color)!;
    } else {
      return Colors.black;
    }
  }
}
