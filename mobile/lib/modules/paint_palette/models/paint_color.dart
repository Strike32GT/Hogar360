import 'package:flutter/material.dart';

class PaintColor {
  const PaintColor({
    required this.name,
    required this.hex,
    required this.family,
    required this.recommendation,
  });

  final String name;
  final String hex;
  final String family;
  final String recommendation;

  Color get color => Color(int.parse('FF${hex.substring(1)}', radix: 16));
}
