import 'package:flutter/painting.dart';

class ConfigConstants {
  static const Color black = Color.fromARGB(255, 41, 41, 41);

  static const Color greyDarkest = Color.fromARGB(255, 106, 106, 106);

  static const Color greyDark = Color.fromARGB(255, 144, 144, 144);

  static const Color greyLight = Color.fromARGB(255, 175, 175, 175);

  static const Color greyLightest = Color.fromARGB(255, 217, 209, 227);

  static const Color white = Color.fromARGB(255, 255, 255, 255);

  static const Color offWhite = Color.fromARGB(255, 237, 237, 237);

  static const Color pink = Color.fromARGB(255, 250, 211, 219);

  static const Color salmon = Color.fromARGB(255, 251, 218, 213);

  static const Color purpleLight = Color.fromARGB(255, 239, 234, 245);

  static const Color purpleDark = Color.fromARGB(255, 103, 44, 140);

  static const Color orange = Color.fromARGB(255, 252, 98, 61);

  static const Color red = Color.fromARGB(255, 244, 54, 93);

  static const Color green = Color.fromARGB(255, 79, 180, 6);

  static const Color gradient1 = Color.fromARGB(255, 234, 31, 118);

  static const Color gradient2 = Color.fromARGB(255, 246, 74, 84);

  static const Color gradient3 = Color.fromARGB(255, 249, 98, 68);

  static const Color backgroundRed = Color.fromARGB(255, 250, 211, 219);

  static const Color backgroundOrange = Color.fromARGB(255, 251, 218, 213);

  static const Color backgroundBlue = Color.fromARGB(255, 217, 209, 227);

  static const Color lightPurple = Color(0xFFDAD2E5);
  static const Color purple = Color(0xFF672E8D);

  static const BoxDecoration loginGradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0,
        0.4,
        0.55,
      ],
      colors: [
        ConfigConstants.gradient1,
        ConfigConstants.gradient2,
        ConfigConstants.gradient3,
      ],
    ),
  );
  static const double paddingGeneral = 25;
  static const double fontHomeGreeting = 28;
  static const double fontDialogTitle = 22;
  static const double fontDialogDescription = 16;
  static const double fontLarge = 20;
  static const double fontCheckoutButton = 22;
  static const double fontToastMessage = 16;
}
