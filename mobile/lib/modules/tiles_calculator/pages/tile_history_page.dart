import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/responsive_page.dart';
import '../models/tile_history_item.dart';
import '../services/tile_history_service.dart';

class TileHistoryPage extends StatefulWidget {
  const TileHistoryPage({super.key});

  @override
  State<TileHistoryPage> createState() => _TileHistoryPageState();
}

class _TileHistoryPageState extends State<TileHistoryPage> {
  final _service = TileHistoryService();
  late final Future<List<TileHistoryItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _service.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Historial de Cálculos'),
      ),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: FutureBuilder<List<TileHistoryItem>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Center(
                child: Text('Aún no tienes cálculos guardados.'),
              );
            }

            return Column(
              children: [
                for (final item in items) ...[
                  _HistoryCard(item: item),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final TileHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: HogarColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFF2E6),
            child: Icon(Icons.grid_view_rounded, color: HogarColors.orange),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compra ${item.boxes} cajas',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.floorArea.toStringAsFixed(2)} m² • ${item.totalTiles} piezas',
                  style: const TextStyle(color: HogarColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
