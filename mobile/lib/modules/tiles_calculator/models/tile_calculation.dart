class TileCalculationInput {
  const TileCalculationInput({
    required this.floorLength,
    required this.floorWidth,
    required this.tileLengthCm,
    required this.tileWidthCm,
    required this.tilesPerBox,
    required this.wastePercentage,
  });

  final double floorLength;
  final double floorWidth;
  final double tileLengthCm;
  final double tileWidthCm;
  final int tilesPerBox;
  final double wastePercentage;
}

class TileCalculationResult {
  const TileCalculationResult({
    required this.floorArea,
    required this.wasteArea,
    required this.recommendedArea,
    required this.floorLength,
    required this.floorWidth,
    required this.tileLengthCm,
    required this.tileWidthCm,
    required this.tilesPerBox,
    required this.tileArea,
    required this.boxArea,
    required this.baseTiles,
    required this.wasteTiles,
    required this.totalTiles,
    required this.boxes,
    required this.wastePercentage,
  });

  final double floorArea;
  final double wasteArea;
  final double recommendedArea;
  final double floorLength;
  final double floorWidth;
  final double tileLengthCm;
  final double tileWidthCm;
  final int tilesPerBox;
  final double tileArea;
  final double boxArea;
  final int baseTiles;
  final int wasteTiles;
  final int totalTiles;
  final int boxes;
  final double wastePercentage;
}
