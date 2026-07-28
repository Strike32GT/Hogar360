import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/session/app_session.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../auth/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    await Future.wait([
      _restoreSession(),
      Future<void>.delayed(const Duration(milliseconds: 900)),
    ]);
    _timer = Timer(Duration.zero, () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppSession.instance.isAuthenticated
            ? AppRoutes.home
            : AppRoutes.welcome,
      );
    });
  }

  Future<void> _restoreSession() async {
    await AppSession.instance.restore();
    await _authService.validateStoredSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: -90,
            left: -80,
            child: _SoftCircle(color: Color(0xFFCFE5FF), size: 260),
          ),
          const Positioned(
            bottom: 70,
            right: -70,
            child: _SoftCircle(color: Color(0xFFFFDCC3), size: 230),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BrandLogoImage(size: 124),
                const SizedBox(height: 26),
                const BrandLogoText(fontSize: 34),
                const SizedBox(height: 12),
                Text(
                  'Calcula materiales para tu hogar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HogarColors.textMuted,
                  ),
                ),
                const SizedBox(height: 84),
                const _LoadingDots(),
                const SizedBox(height: 18),
                Text(
                  'INICIANDO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: HogarColors.outline,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: HogarColors.orange.withValues(alpha: 1 - index * 0.28),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
