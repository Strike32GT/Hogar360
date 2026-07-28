import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/responsive_page.dart';
import '../models/paint_color.dart';
import '../services/paint_palette_service.dart';

class ColorDetailPage extends StatelessWidget {
  ColorDetailPage({super.key, PaintColor? color})
    : color = color ?? PaintPaletteService().getColors().last;

  final PaintColor color;

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          children: [
            Container(
              height: 330,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 28),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: color.color,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wb_sunny_rounded,
                      color: HogarColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      color.recommendation,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              color.name,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: HogarColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                color.hex,
                style: const TextStyle(
                  color: HogarColors.outline,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 34),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HogarColors.surfaceLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: HogarColors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vista previa',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: color.color),
                          const SizedBox(width: 5),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: HogarColors.orange,
                          ),
                          const SizedBox(width: 5),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: HogarColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 118,
                              decoration: BoxDecoration(
                                color: color.color,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 24,
                          bottom: 24,
                          child: Icon(
                            Icons.chair_rounded,
                            size: 82,
                            color: Color(0xFFD8CFC2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: _BenefitCard(
                    icon: Icons.format_paint_rounded,
                    text: 'Gran cubrimiento',
                    color: HogarColors.primary,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _BenefitCard(
                    icon: Icons.eco_rounded,
                    text: 'Bajo en VOC',
                    color: HogarColors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${color.name} guardado')),
                );
              },
              icon: const Icon(Icons.favorite_rounded),
              label: const Text('Guardar color'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
