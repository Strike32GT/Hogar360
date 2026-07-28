import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class Hogar360App extends StatelessWidget {
  const Hogar360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hogar360',
      debugShowCheckedModeBanner: false,
      theme: HogarTheme.light,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
