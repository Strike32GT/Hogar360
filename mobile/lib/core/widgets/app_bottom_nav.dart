import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

enum HogarTab { home, calculator, paint }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.activeTab});

  final HogarTab activeTab;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: const BoxDecoration(
          color: HogarColors.surfaceContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 14,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Inicio',
              selected: activeTab == HogarTab.home,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.home),
            ),
            _NavItem(
              icon: Icons.calculate_rounded,
              label: 'Calculadora',
              selected: activeTab == HogarTab.calculator,
              onTap: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.tilesCalculator,
              ),
            ),
            _NavItem(
              icon: Icons.format_paint_rounded,
              label: 'Pintura',
              selected: activeTab == HogarTab.paint,
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
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : HogarColors.textMuted;
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: selected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 18 : 10,
          vertical: selected ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: selected ? HogarColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
