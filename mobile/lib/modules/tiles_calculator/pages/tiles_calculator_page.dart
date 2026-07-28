import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/responsive_page.dart';
import '../models/tile_calculation.dart';
import '../services/tile_history_service.dart';
import '../viewmodels/tiles_calculator_view_model.dart';

class TilesCalculatorPage extends StatefulWidget {
  const TilesCalculatorPage({super.key});

  @override
  State<TilesCalculatorPage> createState() => _TilesCalculatorPageState();
}

class _TilesCalculatorPageState extends State<TilesCalculatorPage> {
  final _viewModel = TilesCalculatorViewModel();
  final _historyService = TileHistoryService();
  final _floorLength = TextEditingController();
  final _floorWidth = TextEditingController();
  final _tileLength = TextEditingController();
  final _tileWidth = TextEditingController();
  final _tilesPerBox = TextEditingController(text: '10');
  final _waste = TextEditingController(text: '10');
  bool _isSaving = false;

  @override
  void dispose() {
    _viewModel.dispose();
    _floorLength.dispose();
    _floorWidth.dispose();
    _tileLength.dispose();
    _tileWidth.dispose();
    _tilesPerBox.dispose();
    _waste.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    _viewModel.calculate(
      floorLength: _floorLength.text,
      floorWidth: _floorWidth.text,
      tileLength: _tileLength.text,
      tileWidth: _tileWidth.text,
      tilesPerBox: _tilesPerBox.text,
      wastePercentage: _waste.text,
    );
  }

  Future<void> _saveResult(TileCalculationResult result) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      await _historyService.saveResult(result);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resultado guardado')));
    } on TileHistoryException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el resultado')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: HogarColors.primary,
          ),
        ),
        title: const BrandLogoText(),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'Calculadora',
                style: TextStyle(
                  color: HogarColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: HogarTab.calculator),
      body: ResponsivePage(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calculadora de Cerámicos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa las medidas para saber cuántas cajas necesitas comprar.',
                  style: TextStyle(color: HogarColors.textMuted, height: 1.35),
                ),
                const SizedBox(height: 28),
                _SectionTitle(
                  icon: Icons.square_foot_rounded,
                  title: 'Superficie del Piso',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        label: 'Largo',
                        suffix: 'm',
                        controller: _floorLength,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _NumberField(
                        label: 'Ancho',
                        suffix: 'm',
                        controller: _floorWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Divider(color: HogarColors.outlineVariant),
                const SizedBox(height: 18),
                _SectionTitle(
                  icon: Icons.grid_view_rounded,
                  title: 'Detalles del Cerámico',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        label: 'Largo',
                        suffix: 'cm',
                        controller: _tileLength,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _NumberField(
                        label: 'Ancho',
                        suffix: 'cm',
                        controller: _tileWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        label: 'Por caja',
                        suffix: 'uds.',
                        controller: _tilesPerBox,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _NumberField(
                        label: 'Merma',
                        suffix: '%',
                        controller: _waste,
                      ),
                    ),
                  ],
                ),
                if (_viewModel.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _viewModel.errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Calcular'),
                ),
                if (_viewModel.result != null) ...[
                  const SizedBox(height: 28),
                  _ResultCard(
                    result: _viewModel.result!,
                    isSaving: _isSaving,
                    onSave: () => _saveResult(_viewModel.result!),
                    onClear: () {
                      _floorLength.clear();
                      _floorWidth.clear();
                      _tileLength.clear();
                      _tileWidth.clear();
                      _viewModel.clear();
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: HogarColors.orange, size: 22),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: HogarColors.outline,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.suffix,
    required this.controller,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixText: suffix,
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.isSaving,
    required this.onSave,
    required this.onClear,
  });

  final TileCalculationResult result;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: HogarColors.orangeBright,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                bottom: -30,
                child: Icon(
                  Icons.shopping_cart_rounded,
                  size: 118,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESULTADO SUGERIDO',
                    style: TextStyle(
                      color: Color(0xFF633300),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compra ${result.boxes} cajas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF633300),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Superficie total: ${result.recommendedArea.toStringAsFixed(2)} m²',
                    style: const TextStyle(
                      color: Color(0xFF633300),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Área total',
                value: '${result.floorArea.toStringAsFixed(1)} m²',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MetricTile(
                label: 'Piezas totales',
                value: '${result.totalTiles} uds',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Cortes/Desperdicio',
                value: '${result.wasteArea.toStringAsFixed(2)} m²',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MetricTile(
                label: 'Rendimiento/Caja',
                value: '${result.boxArea.toStringAsFixed(2)} m²',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SummaryCard(result: result),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: isSaving ? null : onSave,
          icon: const Icon(Icons.save_rounded),
          label: Text(isSaving ? 'Guardando...' : 'Guardar resultado'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Nuevo cálculo'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            foregroundColor: HogarColors.primary,
            side: const BorderSide(color: HogarColors.primary, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HogarColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: HogarColors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: HogarColors.outline,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.result});

  final TileCalculationResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HogarColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen Técnico',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Metraje neto',
            value: '${result.floorArea.toStringAsFixed(2)} m²',
          ),
          _SummaryRow(
            label:
                'Margen seguridad (+${result.wastePercentage.toStringAsFixed(0)}%)',
            value: '${result.wasteArea.toStringAsFixed(2)} m²',
          ),
          _SummaryRow(
            label: 'Rendimiento/caja',
            value: '${result.boxArea.toStringAsFixed(2)} m²',
          ),
          _SummaryRow(
            label: 'Total cajas',
            value: '${result.boxes}',
            isStrong: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isStrong ? HogarColors.text : HogarColors.textMuted,
                fontWeight: isStrong ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isStrong ? HogarColors.primary : HogarColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
