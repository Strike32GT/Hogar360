import 'dart:math';

import '../models/tile_calculation.dart';

class TileCalculatorService {
  TileCalculationResult calculate(TileCalculationInput input) {
    final floorArea = input.floorLength * input.floorWidth;
    final tileArea = (input.tileLengthCm / 100) * (input.tileWidthCm / 100);
    final boxArea = tileArea * input.tilesPerBox;
    final baseTiles = (floorArea / tileArea).ceil();
    final wasteTiles = (baseTiles * (input.wastePercentage / 100)).ceil();
    final totalTiles = baseTiles + wasteTiles;
    final wasteArea = wasteTiles * tileArea;
    final recommendedArea = totalTiles * tileArea;

    return TileCalculationResult(
      floorArea: floorArea,
      wasteArea: wasteArea,
      recommendedArea: recommendedArea,
      floorLength: input.floorLength,
      floorWidth: input.floorWidth,
      tileLengthCm: input.tileLengthCm,
      tileWidthCm: input.tileWidthCm,
      tilesPerBox: input.tilesPerBox,
      tileArea: tileArea,
      boxArea: boxArea,
      baseTiles: baseTiles,
      wasteTiles: wasteTiles,
      totalTiles: totalTiles,
      boxes: max(1, (totalTiles / input.tilesPerBox).ceil()),
      wastePercentage: input.wastePercentage,
    );
  }
}
