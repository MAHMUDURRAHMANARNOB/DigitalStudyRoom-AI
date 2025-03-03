import 'package:digital_study_room/features/ToolsContent/screens/ToolsContentScreen.dart';
import 'package:digital_study_room/features/Tutor/providers/TutorResponseProvider.dart';
import 'package:digital_study_room/features/Tutor/screens/ChaptersScreen.dart';
import 'package:digital_study_room/features/authentication/providers/AuthProvider.dart';
import 'package:digital_study_room/features/home/screens/widgets/ai_helper_container.dart';
import 'package:digital_study_room/features/home/screens/widgets/card_container_button.dart';
import 'package:digital_study_room/features/home/screens/widgets/home_app_bar.dart';
import 'package:digital_study_room/features/home/screens/widgets/pd_containers.dart';
import 'package:digital_study_room/features/home/screens/widgets/primary_header_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../common/widgets/custom_shapes/containers/searchContainer.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../ToolsContent/screens/SolveBanglaMathScreen.dart';
import '../../Tutor/datamodels/TutorDataModel.dart';
import '../../Tutor/providers/TutorsProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TutorProvider _tutorProvider = TutorProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    bool dark = THelperFunction.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    final fullName = authProvider.user?.name;
    final classId = authProvider.user?.classId;

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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    THomeAppBar(
                      fullName: fullName!,
                      className: classId.toString(),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Let\'s learn ',
                          style: TextStyle(
                              fontSize: 24,
                              color: dark ? Colors.white : Colors.black,
                              fontFamily: "Poppins"),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'in a new way',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            // TextSpan(text: ' world!'),
                          ],
                        ),
                      ),
                    ),
                    // -- TOOLS
                    Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.5,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SolveBanglaMathScreen(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      surfaceTintColor: Colors.transparent,
                                      color: TColors.white,
                                      child: Container(
                                        // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                        // decoration: BoxDecoration(
                                        //   color: TColors.tertiaryColor
                                        //       .withOpacity(0.1),
                                        //   borderRadius: BorderRadius.circular(10.0),
                                        // ),
                                        margin: const EdgeInsets.all(5.0),

                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  // color: TColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Image.asset(
                                                  "assets/images/dashboard_images/math_ttt.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 2.0,
                                                  bottom: 2.0),
                                              child: Text(
                                                "গণিত সমাধান",
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  //*color: Colors.grey.shade900,*//*
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 2.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                "যেকোনো গণিত সমস্যার সমাধান করুন নিমেষে",
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  //*color: Colors.grey.shade900,*//*
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _buildToolCard(
                                          'নোট প্রস্তুতি',
                                          "assets/images/dashboard_images/note.png",
                                          TColors.error,
                                          "NOTE",
                                          "Y",
                                          "Y",
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: _buildToolCard(
                                          'রচনা',
                                          "assets/images/dashboard_images/essay_bn.png",
                                          TColors.primaryColor,
                                          "BANGLAEASSY",
                                          "Y",
                                          "N",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _buildToolCard(
                                          'চিঠি দরখাস্ত',
                                          "assets/images/dashboard_images/letter_bn.png",
                                          TColors.tertiaryColor,
                                          "BANGLALETTER",
                                          "Y",
                                          "N",
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: _buildToolCard(
                                          'ভাবসম্প্রসারণ',
                                          "assets/images/dashboard_images/bhabsomprosaron.png",
                                          TColors.secondaryColor,
                                          "EXP",
                                          "Y",
                                          "N",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: TSizes.sm),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.56,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _buildToolCard(
                                          'Essay',
                                          "assets/images/dashboard_images/essay.png",
                                          TColors.secondaryColor,
                                          "EASSY",
                                          "Y",
                                          "N",
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: _buildToolCard(
                                          'English Grammar',
                                          "assets/images/dashboard_images/grammar.png",
                                          TColors.primaryColor,
                                          "GRAMMAR",
                                          "Y",
                                          "Y",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _buildToolCard(
                                          'Letter',
                                          "assets/images/dashboard_images/letter.png",
                                          TColors.tertiaryColor,
                                          "LETTER",
                                          "Y",
                                          "Y",
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: _buildToolCard(
                                          'Accounting',
                                          "assets/images/dashboard_images/accounting.png",
                                          Colors.redAccent,
                                          "ACC",
                                          "Y",
                                          "N",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ToolsContentScreen(
                                            staticToolsCode: "IMG",
                                            isClassAvailable: "N",
                                            isSubjectAvailable: "N",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: TColors.white,
                                      surfaceTintColor: Colors.transparent,
                                      child: Container(
                                        // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                        // decoration: BoxDecoration(
                                        //   color: TColors.tertiaryColor
                                        //       .withOpacity(0.1),
                                        //   borderRadius: BorderRadius.circular(10.0),
                                        // ),
                                        margin: const EdgeInsets.all(5.0),

                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                // Match the main container's radius
                                                child: Container(
                                                  width: double.infinity,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    "assets/images/dashboard_images/scan_study.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(
                                                "ছবি থেকে সমাধান",
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  //*color: Colors.grey.shade900,*//*
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4,
                                                  bottom: 8),
                                              child: Text(
                                                "যেকোনো প্রশ্নের সমাধান করুন শুধুমাত্র ছবি তুলে।",
                                                // maxLines: 2,

                                                style: TextStyle(
                                                  //*color: Colors.grey.shade900,*//*
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildHorizontalToolCard(
                                  'পরীক্ষক',
                                  "assets/images/dashboard_images/examiner.png",
                                  TColors.error,
                                  "SELF",
                                  "Y",
                                  "Y",
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _buildHorizontalToolCard(
                                  'Programming',
                                  "assets/images/dashboard_images/programmer.png",
                                  TColors.primaryColor,
                                  "ICT",
                                  "Y",
                                  "Y",
                                ),
                              ),
                              const SizedBox(width: TSizes.sm),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // -- TUTOR
                    Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tutors",
                            style: TextStyle(
                                fontSize: 24,
                                color: dark ? Colors.white : Colors.black,
                                fontFamily: "Poppins"),
                          ),
                          SizedBox(
                            height: TSizes.spaceBtwItems / 2,
                          ),
                          FutureBuilder<void>(
                            future: _tutorProvider.fetchTutors(),
                            builder: (context, snapshot) {
                              // Check if data is loading
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: TColors.primaryColor,
                                ));
                              }

                              // Check for errors
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              }

                              // If no tutors available
                              if (!_tutorProvider.tutors.isNotEmpty) {
                                return Center(
                                    child: Text("No tutors available"));
                              }

                              final tutors = _tutorProvider.tutors;

                              // Return scrollable containers for tutors
                              return ListView.builder(
                                itemCount: tutors.length,
                                shrinkWrap: true,
                                // Prevents overflow and keeps the ListView scrollable
                                physics: NeverScrollableScrollPhysics(),
                                // Disable internal scrolling
                                itemBuilder: (context, index) {
                                  final tutor = tutors[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChaptersScreen(
                                            courseTutorName: tutor.tutorName,
                                            subject: tutor.tutorSubjects,
                                            subjectId: tutor.subjectID!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      margin: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            color: TColors.tertiaryColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          tutor.tutorImage != null
                                              ? Image.network(
                                                  tutor.tutorImage!,
                                                  // Placeholder image
                                                  width: 100,
                                                )
                                              : CircleAvatar(
                                                  radius: 40,
                                                  child: Icon(
                                                    CupertinoIcons.person_fill,
                                                    color: Colors.green[900],
                                                    size: 50,
                                                  ),
                                                  backgroundColor: TColors
                                                      .tertiaryColor
                                                      .withOpacity(0.2),
                                                ),
                                          Expanded(
                                            child: Text(
                                              tutor.tutorName,
                                              // Replace with actual tutor name
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: TSizes.spaceBtwItems),
                        ],
                      ),
                    ),

                    // SizedBox(height: TSizes.sm),
                    // -- MENTAL HEALTH
                    Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
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
                                child: _buildToolLargeCard(
                                  'মানসিক স্বাস্থ্য পরামর্শক',
                                  'মানসিক স্বাস্থ্য সম্পর্কে জানুন এবং নিজেকে ভালোবাসুন',
                                  "assets/images/dashboard_images/psychology.png",
                                  TColors.primaryColor,
                                  "MHA",
                                  "Y",
                                  "N",
                                ),
                              ),
                              Expanded(
                                child: _buildToolLargeCard(
                                  'মনোবিজ্ঞানীর সাহায্য',
                                  'হতাশা কাটিয়ে উঠুন, নতুন করে শুরু করুন',
                                  "assets/images/dashboard_images/mental_health.png",
                                  TColors.primaryColor,
                                  "PSY",
                                  "Y",
                                  "N",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildToolCard(
    String title,
    String image,
    Color color,
    String staticToolsCode,
    String isClassAvailable,
    String isSubjectAvailable,
  ) {
    return GestureDetector(
      onTap: () {
        print('$title pressed, $staticToolsCode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToolsContentScreen(
              staticToolsCode: staticToolsCode,
              isClassAvailable: isClassAvailable,
              isSubjectAvailable: isSubjectAvailable,
            ),
          ),
        );
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        margin: const EdgeInsets.all(5.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: 0,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(
                  image,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Text(
              title,
              // maxLines: 2,
              style: TextStyle(
                  /*color: Colors.grey.shade900,*/
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalToolCard(
    String title,
    String image,
    Color color,
    String staticToolsCode,
    String isClassAvailable,
    String isSubjectAvailable,
  ) {
    return GestureDetector(
      onTap: () {
        print('$title pressed, $staticToolsCode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToolsContentScreen(
              staticToolsCode: staticToolsCode,
              isClassAvailable: isClassAvailable,
              isSubjectAvailable: isSubjectAvailable,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                image,
                height: 40,
                width: 40,
              ),
            ),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolLargeCard(
    String title,
    String subtitle,
    String image,
    Color color,
    String staticToolsCode,
    String isClassAvailable,
    String isSubjectAvailable,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ToolsContentScreen(
                    staticToolsCode: staticToolsCode,
                    isClassAvailable: isClassAvailable,
                    isSubjectAvailable: isSubjectAvailable,
                  )),
        );
      },
      child: Container(
        // width: constraints.maxWidth,
        height: 160,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: TColors.primaryColor.withOpacity(0),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.rotate(
              angle: 0,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  image,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  /*color: Colors.grey.shade900,*/
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              subtitle,
              // maxLines: 2,
              style: TextStyle(
                color: TColors.darkGrey, /*fontWeight: FontWeight.bold*/
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
