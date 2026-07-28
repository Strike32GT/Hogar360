import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/session/app_session.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/responsive_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = AppSession.instance.userName ?? 'Usuario';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const BrandLogoText(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: HogarTab.home),
      body: ResponsivePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola de nuevo, $name!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '¿Qué proyecto de renovación tienes en mente hoy? Hagámoslo fácil juntos.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: HogarColors.textMuted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 34),
            _ActionCard(
              icon: Icons.calculate_rounded,
              backgroundIcon: Icons.grid_view_rounded,
              iconColor: HogarColors.primary,
              title: 'Calcular mayólicas',
              subtitle: 'Calcula metros y piezas necesarias para tu piso.',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.tilesCalculator),
            ),
            const SizedBox(height: 18),
            _ActionCard(
              icon: Icons.palette_rounded,
              backgroundIcon: Icons.format_paint_rounded,
              iconColor: HogarColors.orange,
              title: 'Elegir color de pintura',
              subtitle: 'Explora paletas amigables para transformar tu hogar.',
              onTap: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text(
                    'La paleta de pintura estará disponible en una próxima versión.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: HogarColors.outlineVariant,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0x33FC9024),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: HogarColors.orange,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONSEJO CASERO',
                          style: TextStyle(
                            fontSize: 12,
                            color: HogarColors.outline,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Recuerda añadir un 10% extra de material para recortes y desperdicios.',
                          style: TextStyle(
                            color: HogarColors.textMuted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const _RenovationIllustration(),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.backgroundIcon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final IconData backgroundIcon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        height: 214,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: HogarColors.surfaceLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: HogarColors.outlineVariant.withValues(alpha: 0.45),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -26,
              child: Icon(
                backgroundIcon,
                size: 126,
                color: iconColor.withValues(alpha: 0.10),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(right: 46),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: HogarColors.textMuted,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: iconColor,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RenovationIllustration extends StatelessWidget {
  const _RenovationIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 172,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD9EAF7), Color(0xFFFFDCC3)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 26,
            bottom: 28,
            child: Container(
              width: 118,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomPaint(painter: _TilePatternPainter()),
            ),
          ),
          const Positioned(
            right: 28,
            bottom: 30,
            child: Icon(
              Icons.format_paint_rounded,
              size: 80,
              color: HogarColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _TilePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HogarColors.primary.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += size.width / 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
