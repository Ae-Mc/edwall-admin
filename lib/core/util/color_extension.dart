import 'package:flutter/material.dart';

extension ColorExtension on Color {
  int get rb => (r * 255).floor();
  int get gb => (g * 255).floor();
  int get bb => (b * 255).floor();
}
