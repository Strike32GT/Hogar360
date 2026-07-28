import 'package:flutter/foundation.dart';

import '../models/tile_calculation.dart';
import '../services/tile_calculator_service.dart';

class TilesCalculatorViewModel extends ChangeNotifier {
  TilesCalculatorViewModel({TileCalculatorService? service})
    : _service = service ?? TileCalculatorService();

  final TileCalculatorService _service;

  TileCalculationResult? _result;
  String? _errorMessage;

  TileCalculationResult? get result => _result;
  String? get errorMessage => _errorMessage;

  void calculate({
    required String floorLength,
    required String floorWidth,
    required String tileLength,
    required String tileWidth,
    required String tilesPerBox,
    required String wastePercentage,
  }) {
    final input = _parseInput(
      floorLength: floorLength,
      floorWidth: floorWidth,
      tileLength: tileLength,
      tileWidth: tileWidth,
      tilesPerBox: tilesPerBox,
      wastePercentage: wastePercentage,
    );

    if (input == null) {
      _result = null;
      _errorMessage = 'Ingresa valores válidos mayores a cero.';
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _result = _service.calculate(input);
    notifyListeners();
  }

  void clear() {
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  TileCalculationInput? _parseInput({
    required String floorLength,
    required String floorWidth,
    required String tileLength,
    required String tileWidth,
    required String tilesPerBox,
    required String wastePercentage,
  }) {
    final parsedFloorLength = double.tryParse(floorLength.replaceAll(',', '.'));
    final parsedFloorWidth = double.tryParse(floorWidth.replaceAll(',', '.'));
    final parsedTileLength = double.tryParse(tileLength.replaceAll(',', '.'));
    final parsedTileWidth = double.tryParse(tileWidth.replaceAll(',', '.'));
    final parsedTilesPerBox = int.tryParse(tilesPerBox);
    final parsedWaste =
        double.tryParse(wastePercentage.replaceAll(',', '.')) ?? 10;

    final valuesAreValid =
        [
          parsedFloorLength,
          parsedFloorWidth,
          parsedTileLength,
          parsedTileWidth,
          parsedWaste,
        ].every((value) => value != null && value >= 0) &&
        parsedTilesPerBox != null &&
        parsedTilesPerBox > 0 &&
        parsedFloorLength != 0 &&
        parsedFloorWidth != 0 &&
        parsedTileLength != 0 &&
        parsedTileWidth != 0;

    if (!valuesAreValid) return null;

    return TileCalculationInput(
      floorLength: parsedFloorLength!,
      floorWidth: parsedFloorWidth!,
      tileLengthCm: parsedTileLength!,
      tileWidthCm: parsedTileWidth!,
      tilesPerBox: parsedTilesPerBox,
      wastePercentage: parsedWaste,
    );
  }
}
