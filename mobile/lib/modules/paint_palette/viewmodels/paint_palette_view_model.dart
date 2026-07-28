import 'package:flutter/foundation.dart';

import '../models/paint_color.dart';
import '../services/paint_palette_service.dart';

class PaintPaletteViewModel extends ChangeNotifier {
  PaintPaletteViewModel({PaintPaletteService? service})
    : _service = service ?? PaintPaletteService() {
    _colors = _service.getColors();
  }

  final PaintPaletteService _service;
  late final List<PaintColor> _colors;
  String _selectedFamily = 'Todos';

  List<String> get families => const [
    'Todos',
    'Azules',
    'Cálidos',
    'Neutros',
    'Verdes',
  ];
  String get selectedFamily => _selectedFamily;

  List<PaintColor> get colors {
    if (_selectedFamily == 'Todos') return _colors;
    return _colors.where((color) => color.family == _selectedFamily).toList();
  }

  PaintColor get featured => _colors.first;

  void selectFamily(String family) {
    _selectedFamily = family;
    notifyListeners();
  }
}
