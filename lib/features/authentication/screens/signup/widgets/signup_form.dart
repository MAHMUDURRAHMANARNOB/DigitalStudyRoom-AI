import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/SelectClassDataModel.dart';
import '../../../providers/SelectClassProvider.dart';
import '../../../providers/optProvider.dart';
import '../OtpScreen.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneNoTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool checkbox = true;
  String? selectedClass = null;
  bool _obscureText = true;
  bool _isReadOnly = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleReadOnly() {
    setState(() {
      _isReadOnly = !_isReadOnly;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      Provider.of<ClassProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);
    void generateUsername(String fullName) {
      if (fullName.isNotEmpty) {
        // Split the full name into parts
        List<String> nameParts = fullName.trim().split(' ');

        // Take the first part of the full name
        String firstName = nameParts.isNotEmpty ? nameParts[0] : '';

        // Generate random digits
        String randomDigits = Random().nextInt(10000).toString();

        // Build username by appending random digits to the first part of the name
        String username = firstName + randomDigits;

        // Update the username field
        setState(() {
          _userNameController.text = username;
          // print(username);
        });
      } else {
        // Clear the username field if the full name is empty
        setState(() {
          _userNameController.text = '';
        });
      }
    }

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Name and Last Name
          TextFormField(
            controller: _fullNameController,
            cursorColor: TColors.primaryColor,
            expands: false,
            onChanged: (value) {
              setState(() {
                generateUsername(value);
              });
            },
            decoration: const InputDecoration(
                labelText: TTexts.fullName, prefixIcon: Icon(Iconsax.user)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //   UserName
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "UserName",
              ),
              TextField(
                controller: _userNameController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: TColors.primaryColor,
                readOnly: _isReadOnly,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Iconsax.verify,
                    color: TColors.grey, // Change the color of the icon
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isReadOnly ? Icons.edit : Icons.edit_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: _toggleReadOnly,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Generated Username',
                  filled: true,
                  fillColor: TColors.white,
                  // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            TColors.primaryColor), // Border color when focused
                    borderRadius: BorderRadius.circular(
                        10.0), // Border radius when focused
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //   Email
          TextFormField(
            controller: _emailTextController,
            cursorColor: TColors.primaryColor,
            keyboardType: TextInputType.emailAddress,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //   Phone No
          TextFormField(
            controller: _phoneNoTextController,
            cursorColor: TColors.primaryColor,
            expands: false,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //   Password
          TextFormField(
            obscureText: _obscureText,
            controller: _passwordTextController,
            cursorColor: TColors.primaryColor,
            expands: false,
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Class
          Text(
            "আপনার ক্লাস সম্পর্কে নিশ্চিত হোন।",
            style: TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 5),
          FutureBuilder<List<ClassModel>>(
            future: Provider.of<ClassProvider>(context, listen: false)
                .loadClasses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SpinKitThreeInOut(
                        color: TColors.primaryColor, size: 30));
              } else if (snapshot.hasError) {
                return const Center(child: Text("Failed to load classes"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No classes available"));
              }

              List<ClassModel> classList = snapshot.data!;

              return DropdownButtonFormField<String>(
                value: selectedClass,
                hint: const Text("Select your class"),
                isExpanded: true,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  // contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: TColors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: TColors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: TColors.tertiaryColor, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(
                  color: selectedClass != null
                      ? TColors.tertiaryColor
                      : TColors.grey, // Changes selected text color to green
                  fontSize: 16,
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: classList.map((classItem) {
                  return DropdownMenuItem<String>(
                    value: classItem.id.toString(),
                    child: Text(
                      classItem.className,
                      style: TextStyle(
                        color: selectedClass == classItem.id.toString()
                            ? TColors.tertiaryColor
                            : Colors.black, // Green text for selected item
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClass = value;
                    print(selectedClass);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 5),
          Text(
            "পরবর্তীতে ক্লাস পরিবর্তনের ক্ষেত্রে DigitalStudyRoom এর সাথে যোগাযোগ করতে হবে।",
            style: TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.end,
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          //   Terms and condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: checkbox,
                  activeColor: TColors.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      checkbox = !checkbox;
                    });
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: TTexts.iAgreeTo,
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                        text: " ${TTexts.privacyPolicy} ",
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: widget.dark
                                  ? TColors.white
                                  : TColors.primaryColor,
                              // decoration: TextDecoration.underline,
                              decorationColor: widget.dark
                                  ? TColors.white
                                  : TColors.primaryColor,
                            ),
                      ),
                      TextSpan(
                          text: "and",
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                        text: " ${TTexts.termsOfUse} ",
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: widget.dark
                                  ? TColors.white
                                  : TColors.primaryColor,
                              // decoration: TextDecoration.underline,
                              decorationColor: widget.dark
                                  ? TColors.white
                                  : TColors.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //   Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible:
                      true, // Set to false to make it non-cancelable
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black
                                .withOpacity(0.5), // Adjust opacity as needed
                          ),
                        ),
                        AlertDialog(
                          backgroundColor: TColors.white,
                          contentPadding: EdgeInsets.all(10.0),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SpinKitThreeInOut(
                                color: TColors.primaryColor,
                              ),
                              Image.asset(
                                "assets/icons/digitlaStudyRoom.png",
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );

                String fullName = _fullNameController.text.trim();
                String userName = _userNameController.text.trim();
                String emailAddress = _emailTextController.text.trim();
                String mobileNo = _phoneNoTextController.text.trim();
                String password = _passwordTextController.text.trim();

                if (checkbox &&
                    emailAddress.isNotEmpty &&
                    mobileNo.isNotEmpty &&
                    fullName.isNotEmpty &&
                    userName.isNotEmpty &&
                    password.isNotEmpty &&
                    selectedClass != null) {
                  await otpProvider.fetchOtp(emailAddress, mobileNo);

                  print("OTP IS: ${otpProvider.otpResponseModel!.otp}");
                  if (otpProvider.otpResponseModel != null &&
                      otpProvider.otpResponseModel!.otp != null) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyEmailScreen(
                                otp: otpProvider.otpResponseModel?.otp ?? 0,
                                userName: userName.toString(),
                                fullName: fullName.toString(),
                                email: emailAddress.toString(),
                                mobile: mobileNo.toString(),
                                password: password.toString(),
                                selectedClass: selectedClass.toString(),
                              )),
                    );
                  } else {
                    Navigator.pop(context);
                    CustomSnackBar(context, TColors.error, "OOPS!",
                        otpProvider.otpResponseModel!.message);
                  }
                } else {
                  Navigator.pop(context);
                  if (_emailTextController.value == null) {
                    CustomSnackBar(context, TColors.error, "দুঃখিত!",
                        "অনুগ্রহ করে আপনার ইমেইল প্রদান করুন।");
                  } else if (_phoneNoTextController.text.length < 11) {
                    CustomSnackBar(context, TColors.error, "দুঃখিত!",
                        "অনুগ্রহ করে সঠিক মোবাইল নম্বর প্রদান করুন।");
                  } else if (_passwordTextController.text.length < 6) {
                    CustomSnackBar(context, TColors.error, "দুঃখিত!",
                        "অনুগ্রহ করে সর্বনিম্ন ৬ অক্ষরের পাসওয়ার্ড প্রদান করুন।");
                  } else {
                    CustomSnackBar(context, TColors.error, "দুঃখিত!",
                        "অনুগ্রহ করে সকল তথ্য প্রদান করুন।");
                  }
                }
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }

  void CustomSnackBar(
      BuildContext context, Color bgcolor, String heading, String subHeading) {
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
                    color: bgcolor, borderRadius: BorderRadius.circular(20.0)),
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
                            heading,
                            style:
                                TextStyle(fontSize: 18.0, color: TColors.white),
                          ),
                          Text(
                            subHeading,
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
