import 'package:flutter/material.dart';

import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/home/pages/splash_page.dart';
import '../modules/home/pages/welcome_page.dart';
import '../modules/paint_palette/models/paint_color.dart';
import '../modules/paint_palette/pages/color_detail_page.dart';
import '../modules/paint_palette/pages/paint_palette_page.dart';
import '../modules/profile/pages/profile_page.dart';
import '../modules/tiles_calculator/pages/tile_history_page.dart';
import '../modules/tiles_calculator/pages/tiles_calculator_page.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const tilesCalculator = '/tiles-calculator';
  static const paintPalette = '/paint-palette';
  static const colorDetail = '/color-detail';
  static const profile = '/profile';
  static const tileHistory = '/tile-history';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    welcome: (_) => const WelcomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const HomePage(),
    tilesCalculator: (_) => const TilesCalculatorPage(),
    paintPalette: (_) => const PaintPalettePage(),
    profile: (_) => const ProfilePage(),
    tileHistory: (_) => const TileHistoryPage(),
    colorDetail: (context) {
      final color = ModalRoute.of(context)?.settings.arguments;
      return ColorDetailPage(color: color is PaintColor ? color : null);
    },
  };
}
