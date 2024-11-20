import 'package:digital_study_room/features/home/screens/widgets/ai_helper_container.dart';
import 'package:digital_study_room/features/home/screens/widgets/card_container_button.dart';
import 'package:digital_study_room/features/home/screens/widgets/home_app_bar.dart';
import 'package:digital_study_room/features/home/screens/widgets/pd_containers.dart';
import 'package:digital_study_room/features/home/screens/widgets/primary_header_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../common/widgets/custom_shapes/containers/searchContainer.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -150,
            right: -150,
            child: TCircularContainer(
              backgroundColor: TColors.tertiaryColor.withOpacity(0.1),
            ),
          ),
          Positioned(
            top: 100,
            right: -250,
            child: TCircularContainer(
              backgroundColor: TColors.tertiaryColor.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: TCircularContainer(
              backgroundColor: TColors.secondaryColor.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -250,
            child: TCircularContainer(
              backgroundColor: TColors.secondaryColor.withOpacity(0.1),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        // Appbar
                        THomeAppBar(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(

                              text:  TextSpan(
                                text: 'Let\'s learn ',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: dark?Colors.white:Colors.black,
                                    fontFamily: "Poppins"),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'in a new way',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                  // TextSpan(text: ' world!'),
                                ],
                              ),
                            ),
                            SizedBox(height: TSizes.spaceBtwItems),
                            //Classroom
                            Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.md / 2,
                                        horizontal: TSizes.md),
                                    // height: 150,
                                    decoration: BoxDecoration(
                                      color: /*dark ? TColors.dark : TColors.light*/
                                          TColors.primaryColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(
                                          TSizes.borderRadiusLg),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0.0, 0.0, 0.0, 5.0),
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  "Classroom",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                              Text(
                                                textAlign: TextAlign.start,
                                                "ইন্টারেক্টিভ লেসন এবং ভিডিও দেখে পড়া শুরু করুন",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          TImages.cvBuilderImage,
                                          height: 100,
                                          width: 150,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -300,
                                    right: -180,
                                    child: TCircularContainer(
                                      backgroundColor:
                                          TColors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: TSizes.spaceBtwItems / 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // SizedBox(height: TSizes.defaultSpace),
                    // TOOLS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Explore The AI Tools",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: TSizes.sm,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildToolCard(
                              'গণিত \nসমাধান',
                              "assets/images/dashboard_images/maths.png",
                              TColors.tertiaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'নোট \nপ্রস্তুতি',
                              "assets/images/dashboard_images/note_helper.png",
                              TColors.secondaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'চিঠি\n ',
                              "assets/images/dashboard_images/letter.png",
                              TColors.primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildToolCard(
                              'রচনা \n ',
                              "assets/images/dashboard_images/essay.png",
                              TColors.secondaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'পরীক্ষক \n ',
                              "assets/images/dashboard_images/examiner.png",
                              TColors.tertiaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'ছবি থেকে\nপড়া',
                              "assets/images/dashboard_images/scanner.png",
                              TColors.secondaryColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: _buildToolCard(
                              'English\nGrammar',
                              "assets/images/dashboard_images/grammar.png",
                              TColors.tertiaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'Essay\n',
                              "assets/images/dashboard_images/essay.png",
                              TColors.secondaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'Letter\n',
                              "assets/images/dashboard_images/letter.png",
                              TColors.primaryColor),
                        ),
                      ],
                    ),
                    SizedBox(height: TSizes.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Mental Health Support AI Tools",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: TSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: _buildToolCard(
                              'মানসিক স্বাস্থ্য \nপরামর্শদাতা',
                              "assets/images/dashboard_images/psychology.png",
                              TColors.secondaryColor),
                        ),
                        Expanded(
                          child: _buildToolCard(
                              'মনোবিজ্ঞানীর \nসাহায্য',
                              "assets/images/dashboard_images/mental_health.png",
                              TColors.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(String title, String image, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          SizedBox(
            height: TSizes.spaceBtwItems / 2,
          ),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(
                color: Colors.grey.shade900, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
