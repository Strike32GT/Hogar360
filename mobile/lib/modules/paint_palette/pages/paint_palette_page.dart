import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/responsive_page.dart';
import '../models/paint_color.dart';
import '../viewmodels/paint_palette_view_model.dart';

class PaintPalettePage extends StatefulWidget {
  const PaintPalettePage({super.key});

  @override
  State<PaintPalettePage> createState() => _PaintPalettePageState();
}

class _PaintPalettePageState extends State<PaintPalettePage> {
  final _viewModel = PaintPaletteViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openDetail(PaintColor color) {
    Navigator.pushNamed(context, AppRoutes.colorDetail, arguments: color);
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: HogarTab.paint),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paleta de Pintura',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encuentra el tono perfecto para transformar tu hogar con un toque profesional.',
                  style: TextStyle(color: HogarColors.textMuted, height: 1.35),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _viewModel.families.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final family = _viewModel.families[index];
                      return ChoiceChip(
                        label: Text(family),
                        selected: _viewModel.selectedFamily == family,
                        onSelected: (_) => _viewModel.selectFamily(family),
                        selectedColor: HogarColors.primary,
                        labelStyle: TextStyle(
                          color: _viewModel.selectedFamily == family
                              ? Colors.white
                              : HogarColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                          side: BorderSide.none,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                _FeaturedColor(
                  color: _viewModel.featured,
                  onTap: () => _openDetail(_viewModel.featured),
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 430 ? 3 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _viewModel.colors.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final color = _viewModel.colors[index];
                        return _ColorCard(
                          paintColor: color,
                          onTap: () => _openDetail(color),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HogarColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: HogarColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: HogarColors.primaryContainer,
                        child: Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Observa cómo cambia el tono bajo diferentes luces antes de decidirte por completo.',
                          style: TextStyle(
                            color: HogarColors.primary,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedColor extends StatelessWidget {
  const _FeaturedColor({required this.color, required this.onTap});

  final PaintColor color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 238,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.color, HogarColors.primaryContainer],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -20,
              child: Icon(
                Icons.format_paint_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              left: 22,
              bottom: 22,
              right: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: HogarColors.orange,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'DESTACADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    color.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${color.hex} • Familia ${color.family}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({required this.paintColor, required this.onTap});

  final PaintColor paintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: HogarColors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: paintColor.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              paintColor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              paintColor.hex,
              style: const TextStyle(
                color: HogarColors.textMuted,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: paintColor.color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    paintColor.family.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: HogarColors.outline,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
