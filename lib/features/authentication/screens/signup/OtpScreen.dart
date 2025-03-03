import 'dart:ui';

import 'package:digital_study_room/features/home/screens/home.dart';
import 'package:digital_study_room/navigation_menu.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/widgets/success_screen/sign_up_success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/error_dialog.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../providers/AuthProvider.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatefulWidget {
  final int? otp;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? mobile;
  final String? password;
  final String? selectedClass;

  const VerifyEmailScreen(
      {super.key,
      required this.email,
      required this.mobile,
      this.otp,
      this.userName,
      this.fullName,
      this.password,
      this.selectedClass});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late String? otpCode;
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.otp == null) {
      // Handle the case where otp is null, for example, show a loading indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    print(widget.otp);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //   Image
              Image(
                image: AssetImage(TImages.verifyEmailImage),
                width: THelperFunction.screenWidth(context) * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //   Title and email and subtitle
              Text(
                TTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                "${widget.email}",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.confirmEmailSubtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _otpController,
                cursorColor: TColors.primaryColor,
                onChanged: (String verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.verified_user_rounded,
                    color: TColors.primaryColor,
                  ),
                  labelText: "Enter OTP here",
                  labelStyle: TextStyle(color: TColors.primaryColor),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //   Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Set to false to make it non-cancelable
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.black.withOpacity(
                                    0.5), // Adjust opacity as needed
                              ),
                            ),
                            AlertDialog(
                              backgroundColor: TColors.white,
                              contentPadding: EdgeInsets.all(10.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Matching OTP'),
                                  SpinKitThreeInOut(
                                    color: TColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (otpCode!.isNotEmpty && otpCode == widget.otp.toString()) {
                      final response = await Provider.of<AuthProvider>(context,
                              listen: false)
                          .createUser(
                        // Pass parameters for user creation
                        widget.userName!,
                        widget.userName!,
                        widget.fullName!,
                        widget.email!,
                        widget.mobile!,
                        widget.password!,
                        "S",
                        "not-mentioned",
                        "not-mentioned",
                        "not-mentioned",
                        widget.selectedClass!,
                      );

                      print("Response is: ${response}");

                      if (response == true) {
                        /*showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Success"),
                          content: Text(
                              'User created successfully! Logging you in...'),
                        ),
                      );*/
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Set to false to make it non-cancelable
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    color: Colors.black.withOpacity(
                                        0.5), // Adjust opacity as needed
                                  ),
                                ),
                                AlertDialog(
                                  backgroundColor:TColors.white,
                                  title: Center(child: Text("Success")),
                                  contentPadding: EdgeInsets.all(10.0),
                                  content: Column(

                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'User created successfully! Logging you in'),
                                      SpinKitThreeInOut(
                                        color: TColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        try {
                          // Call the login method from the AuthProvider
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .login(widget.email!, widget.password!);

                          // Check if the user is authenticated
                          if (Provider.of<AuthProvider>(context, listen: false)
                                  .user !=
                              null) {
                            // Navigate to the DashboardScreen on successful login
                            Navigator.pop(context);
                            _saveCredentials(widget.email!,widget.password!);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationMenu()),
                              (route) => false,
                            );
                          } else {
                            // Handle unsuccessful login
                            print("Login failed");
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message:
                                      "Login failed, check username and password.",
                                );
                              },
                            );
                          }
                        } catch (error) {
                          // Handle errors from the API call or login process
                          print("Error during login: $error");
                          // Show the custom error dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(message: error.toString());
                            },
                          );
                        }
                      } else if (response == false) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                'User Already exist, either user id, mobile,email matched with other user'),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text('Unexpected response format.'),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text('OTP did not match'),
                        ),
                      );
                    }
                  },
                  child: const Text(TTexts.tContinue),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () {},
                child: const Text(
                  TTexts.resendEmail,
                  style: TextStyle(color: TColors.textPrimary),
                ),
              ),
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
