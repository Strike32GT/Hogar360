class TileHistoryItem {
  const TileHistoryItem({
    required this.id,
    required this.floorArea,
    required this.totalTiles,
    required this.boxes,
    required this.createdAt,
  });

  final String id;
  final double floorArea;
  final int totalTiles;
  final int boxes;
  final DateTime createdAt;

  factory TileHistoryItem.fromJson(Map<String, dynamic> json) {
    return TileHistoryItem(
      id: json['id'] as String? ?? '',
      floorArea: (json['floorArea'] as num?)?.toDouble() ?? 0,
      totalTiles: (json['totalTiles'] as num?)?.toInt() ?? 0,
      boxes: (json['boxes'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
