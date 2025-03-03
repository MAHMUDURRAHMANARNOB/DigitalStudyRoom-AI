import 'package:concentric_transition/concentric_transition.dart';
import 'package:digital_study_room/features/authentication/screens/onBoarding/widgets/onboarding_dot_navigation.dart';
import 'package:digital_study_room/features/authentication/screens/onBoarding/widgets/onboarding_next_button.dart';
import 'package:digital_study_room/features/authentication/screens/onBoarding/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import '../../providers/AuthProvider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check for stored credentials and attempt auto-login
    autoLogin();
  }

  void autoLogin() async {
    try {
      // Get stored credentials from a secure storage mechanism
      String? username = await _getStoredUsername();
      String? password = await _getStoredPassword();

      if (username != null && password != null) {
        // Call the login method from the AuthProvider
        await Provider.of<AuthProvider>(context, listen: false)
            .login(username, password);

        // Check if the user is authenticated
        if (Provider.of<AuthProvider>(context, listen: false).user != null) {
          // Navigate to the DashboardScreen on successful login
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationMenu()));
        }
      }
    } catch (error) {
      // Handle errors, if any
      print("Auto-login error: $error");
    } finally {
      // Set isLoading to false after auto-login attempt is finished
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getStoredUsername() async {
    // Implement this method to retrieve the stored username
    // For example, use SharedPreferences or secure storage library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> _getStoredPassword() async {
    // Implement this method to retrieve the stored password
    // For example, use SharedPreferences or secure storage library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: _isLoading
          ? Center(
              child: SpinKitThreeInOut(
                color: TColors.primaryColor,
              ), // Show loading indicator
            )
          : Stack(
              children: [
                // Skip Button
                // const OnBoardingSkip(),

                // Dot Navigation SmoothPageIndicator
                const OnBoardingDotNavigation(),

                //Horizontal Scrollable Pages
                PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updatePageIndicator,
                  children: const [
                    OnBoardingPage(
                      image: TImages.onBoardingImage1,
                      title: TTexts.onBoardingTitle1,
                      subTitle: TTexts.onBoardingSubTitle1,
                    ),
                    OnBoardingPage(
                      image: TImages.onBoardingImage2,
                      title: TTexts.onBoardingTitle2,
                      subTitle: TTexts.onBoardingSubTitle2,
                    ),
                    OnBoardingPage(
                      image: TImages.onBoardingImage3,
                      title: TTexts.onBoardingTitle3,
                      subTitle: TTexts.onBoardingSubTitle3,
                    ),
                  ],
                ),

                //Circular Button
                const OnBoardingNextButton(),
              ],
            ),
    );
  }
}
