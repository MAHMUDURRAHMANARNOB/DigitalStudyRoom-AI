import 'package:digital_study_room/features/AiTutor/screens/GetCoursesAiTutorScreen.dart';
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
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../ToolsContent/screens/SolveBanglaMathScreen.dart';
import '../../Tutor/providers/TutorsProvider.dart';
import '../../Tutor/screens/TutorListScreen.dart';

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

                    SizedBox(height: TSizes.sm),
                    // -- NCTB AI TUTOR
                    buildNCTBAITutor(context, userId, classId),

                    SizedBox(height: TSizes.sm),

                    // -- TOOLS

                    Container(
                      padding: EdgeInsets.symmetric(horizontal:8.0),
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
                          SizedBox(height: TSizes.sm),
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

                    SizedBox(height: TSizes.spaceBtwItems),
                    // -- TUTOR
                    buildVoiceTutor(context),


                    SizedBox(height: TSizes.sm),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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

  GestureDetector buildNCTBAITutor(BuildContext context, int? userId, int? classId) {
    return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetCourseAiTutorListScreen(
                            userId: userId.toString(),
                            classId: classId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4B1248),  // Dark purple
                              Color(0xFF2A0D2A),  // Slightly lighter than 1B1B1B for gradient smoothness
                              /*Color(0xFF2C3E50),  // Dark navy
                              Color(0xFF4CA1AF),*/
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: Offset(0, 6)
                      ),],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background glow effect
                        Positioned(
                          right: -30,
                          bottom: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: TColors.secondaryColorEnhanced.withOpacity(0.1),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Text Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Badge
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: TColors.secondaryColorEnhanced.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: TColors.secondaryColorEnhanced.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            "NEW FEATURE",
                                            style: TextStyle(
                                              color: TColors.secondaryColorEnhanced,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12),

                                        // Main Headers
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Master NCTB Books\n",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.2,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "with Your ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.2,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "AI Tutor",
                                                style: TextStyle(
                                                  color: TColors.secondaryColorEnhanced,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 8),

                                        // Description
                                        Text(
                                          "Interactive lessons, instant explanations, and personalized learning",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 16),

                                  // Image Container
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/dashboard_images/teacher_nctb.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // CTA Button
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      TColors.secondaryColorEnhanced.withOpacity(0.8),
                                      Color(0xFFFFC000),
                                    ],
                                  ),
                                  // color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TColors.secondaryColorEnhanced.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, color: Colors.black, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Start Learning Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
  }

  GestureDetector buildVoiceTutor(BuildContext context) {
    return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TutorsListScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            /*Color(0xFF4B1248),  // Dark purple
                            Color(0xFF2A0D2A),*/  // Slightly lighter than 1B1B1B for gradient smoothness
                            TColors.buttonPrimary,  // Dark navy
                            TColors.info,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Left side - Icon with circular background
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.headphones, // Simple intuitive icon
                              color: TColors.white,
                              size: 30,
                            ),
                          ),

                          SizedBox(width: 16),

                          // Middle - Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Interactive Voice Tutors",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Learn from expert tutors in Bangla medium curriculum",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right side - Arrow with circle
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: TColors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: TColors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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
        // height: 200,
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
