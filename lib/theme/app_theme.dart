import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF006181);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color navBarColor = Color(0xFF49454F);
  static const Color backgroundColor = Color(0xFFEDF0F7);

  static TextStyle get karlaRegular => const TextStyle(
        fontFamily: 'Karla',
        fontWeight: FontWeight.w400,
        fontSize: 24,
        color: white,
      );

  static TextStyle get karlaBold => karlaRegular.copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle get karlaBlue => karlaBold.copyWith(
        color: primaryBlue,
      );


  static TextStyle get scheduleSubtitle => const TextStyle(
        fontFamily: 'Karla',
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: black,
      );

   static const TextStyle scheduleTitle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Color(0xFF008EBD),
);



  static TextStyle get navBarLabel => const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: navBarColor,
        letterSpacing: 0.5,
      );
}