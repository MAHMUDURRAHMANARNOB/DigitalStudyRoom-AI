import 'package:digital_study_room/features/authentication/screens/login/widgets/login_form.dart';
import 'package:digital_study_room/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              const TLoginForm(),

              ///divider
              TFormDivider(dark: dark, dividerText: TTexts.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Footer
              const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
