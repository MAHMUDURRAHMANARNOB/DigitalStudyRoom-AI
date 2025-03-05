import 'package:digital_study_room/features/authentication/screens/login/widgets/login_form.dart';
import 'package:digital_study_room/features/authentication/screens/login/widgets/login_header.dart';
import 'package:digital_study_room/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../providers/AuthProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NavigationMenu()));
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
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Logo, Title SubTitle
              TLoginHeader(dark: dark),

              ///Form
              _isLoading
                  ?  Center(
                child: SpinKitThreeInOut(
                  color: TColors.primaryColor,
                ), // Show loading indicator
              )
                  : // Show login form when not loading
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: TLoginForm(
                  onLoginSuccess: _saveCredentials,
                ),
              ),

              ///divider
              // TFormDivider(dark: dark, dividerText: TTexts.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Footer
              // const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
  void _saveCredentials(String username, String password) async {
    // Save the username and password using SharedPreferences
    // You can implement this similarly to how you retrieve them
    // Example:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }
}
