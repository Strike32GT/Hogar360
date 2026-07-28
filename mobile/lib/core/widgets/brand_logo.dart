import 'package:flutter/material.dart';

import '../../app/theme.dart';

class BrandLogoText extends StatelessWidget {
  const BrandLogoText({super.key, this.fontSize = 24});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        children: const [
          TextSpan(
            text: 'Hogar',
            style: TextStyle(color: HogarColors.orange),
          ),
          TextSpan(
            text: '360',
            style: TextStyle(color: HogarColors.primary),
          ),
        ],
      ),
    );
  }
}

class BrandLogoImage extends StatelessWidget {
  const BrandLogoImage({super.key, this.size = 124, this.withText = false});

  final double size;
  final bool withText;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      withText
          ? 'assets/Hogar_360_Logo.png'
          : 'assets/Hogar_360_Logo_Recortado.png',
      width: size,
      fit: BoxFit.contain,
    );
  }
}
