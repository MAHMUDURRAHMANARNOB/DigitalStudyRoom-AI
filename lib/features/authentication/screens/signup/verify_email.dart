import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/sign_up_success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          )
        ],
      ),
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
                "email@gmail.com",
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

              //   Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SignUpSuccessScreen(
                        image: TImages.successEmailImage,
                        title: TTexts.accountCreatedTitle,
                        subTitle: TTexts.accountCreatedSubTitle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
                          );
                          // Get.offAll(() => LoginScreen());
                        },
                      )),
                    );
                    /*Navigator.push(context, route);
                     SignUpSuccessScreen(
                          image: TImages.successEmailImage,
                          title: TTexts.accountCreatedTitle,
                          subTitle: TTexts.accountCreatedSubTitle,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
                            );
                            // Get.offAll(() => LoginScreen());
                          },
                        );*/
                  },
                  child: const Text(TTexts.tContinue),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () {},
                child: const Text(TTexts.resendEmail,style: TextStyle(color: TColors.textPrimary),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
