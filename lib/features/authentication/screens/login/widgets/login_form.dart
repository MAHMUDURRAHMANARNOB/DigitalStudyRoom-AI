import 'package:digital_study_room/features/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/UserDataModel.dart';
import '../../../providers/AuthProvider.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatefulWidget {
  final Function(String, String) onLoginSuccess;
  const TLoginForm({
    super.key, required this.onLoginSuccess,
  });

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  // Initially hide the password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing while loading
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TColors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitHourGlass(color: TColors.primaryColor),
                  SizedBox(height: 5.0),
                  Image.asset(
                    "assets/icons/digitlaStudyRoom.png",
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    bool success = await authProvider.login(
      _userIdController.text,
      _passwordController.text,
    );
    // Close loader
    Navigator.of(context).pop();
    // print(">> handle Login : ${_userIdController.text} -- ${_passwordController.text} -- $success");
    if (success) {
      User user =
      Provider.of<AuthProvider>(context, listen: false).user!;
      print("User ID: ${user.userId}");
      print("Username: ${user.username}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationMenu()));
      widget.onLoginSuccess(_userIdController.text, _passwordController.text,);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          content: Stack(
            children: [
              Container(
                  padding: EdgeInsets.all(16.0),
                  height: 90,
                  decoration: BoxDecoration(
                      color: TColors.error,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/oops.png",
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ohh snap!",
                              style: TextStyle(
                                  fontSize: 18.0, color: TColors.white),
                            ),
                            Text(
                              'Invalid credentials!',
                              style:
                                  TextStyle(fontSize: 12, color: TColors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: _userIdController,
              cursorColor: TColors.primaryColor,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            TextFormField(
              obscureText: _obscureText,
              controller: _passwordController,
              cursorColor: TColors.primaryColor,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,

                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields / 2,
            ),

            //   Remember Me and Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///RememberMe
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: TColors.primaryColor,
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                ///ForgetPass
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()),
                    );
                  },
                  child: const Text(
                    TTexts.forgetPassword,
                    style: TextStyle(color: TColors.primaryColor),
                  ),
                )
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            //   Sign In Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor),
                onPressed:
                    () => /*Navigator.push(

                  context,
                  MaterialPageRoute(builder: (context) => const NavigationMenu()),
                ),*/
                        _handleLogin(),
                child: const Text("Login"),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            //   Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text(TTexts.createAccount),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
