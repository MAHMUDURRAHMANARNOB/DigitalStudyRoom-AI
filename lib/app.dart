import 'package:digital_study_room/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/screens/onBoarding/onboarding.dart';

//  -- Use This Class to setup themes, initial bindings or provider any animations and much more

class DigitalStudyRoom extends StatelessWidget {
  const DigitalStudyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
  }
}
