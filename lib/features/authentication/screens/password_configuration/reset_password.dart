import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                // Get.back();
                Navigator.pop(context);

              },
              icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: Scaffold(
        // appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: TSpacingStyles.paddingWithAppBarHeight * 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Image
                Image(
                  image: AssetImage(TImages
                      .successEmailImage) /*AssetImage(TImages.successEmailImage)*/,
                  width: THelperFunction.screenWidth(context) * 0.6,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                ///Title and Subtitle
                Text(
                  TTexts.resetPassSuccessTitle /*TTexts.accountCreatedTitle*/,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                Text(
                  TTexts
                      .resetPassSuccessSubTitle /*TTexts.accountCreatedSubTitle*/,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                ///Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.offAll(() => Dashboard());
                      // onPressed!();
                    },
                    child: const Text(TTexts.tContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
