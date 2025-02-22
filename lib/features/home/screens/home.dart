import 'package:digital_study_room/features/ToolsContent/screens/ToolsContentScreen.dart';
import 'package:digital_study_room/features/Tutor/providers/TutorResponseProvider.dart';
import 'package:digital_study_room/features/Tutor/screens/ChaptersScreen.dart';
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
    final userId = 2;

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
                    const THomeAppBar(),
                    // SizedBox(height: TSizes.defaultSpace),
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
                    // SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      /*decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),*/
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildToolCard(
                                    'গণিত \nসমাধান',
                                    "assets/images/dashboard_images/math.png",
                                    TColors.primaryColor,
                                    "MATH"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                  'নোট \nপ্রস্তুতি',
                                  "assets/images/dashboard_images/note.png",
                                  TColors.error,
                                  "NOTE",
                                ),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'রচনা \n ',
                                    "assets/images/dashboard_images/essay_bn.png",
                                    TColors.secondaryColor,
                                    "BANGLAEASSY"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'চিঠি\n দরখাস্ত',
                                    "assets/images/dashboard_images/letter_bn.png",
                                    TColors.tertiaryColor,
                                    "BANGLALETTER"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildToolCard(
                                    'ভাবসম্প্রসারণ\n',
                                    "assets/images/dashboard_images/bhabsomprosaron.png",
                                    TColors.secondaryColor,
                                    "EXP"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'পরীক্ষক \n ',
                                    "assets/images/dashboard_images/examiner.png",
                                    TColors.error,
                                    "SELF"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'ছবি থেকে\nপড়া',
                                    "assets/images/dashboard_images/scan.png",
                                    TColors.tertiaryColor,
                                    "IMG"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'English\nGrammar',
                                    "assets/images/dashboard_images/grammar.png",
                                    TColors.primaryColor,
                                    "GRAMMAR"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // flex: 1,
                                child: _buildToolCard(
                                    'Letter',
                                    "assets/images/dashboard_images/letter.png",
                                    TColors.primaryColor,
                                    "LETTER"),
                              ),
                              Expanded(
                                // flex: 1,
                                child: _buildToolCard(
                                    'Accounting',
                                    "assets/images/dashboard_images/accounting.png",
                                    TColors.secondaryColor,
                                    "ACC"),
                              ),
                              Expanded(
                                child: _buildToolCard(
                                    'Essay',
                                    "assets/images/dashboard_images/essay.png",
                                    TColors.secondaryColor,
                                    "EASSY"),
                              ),
                              Expanded(
                                // flex: 1,
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: TSizes.sm),
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
                                    child: CircularProgressIndicator(color: TColors.primaryColor,));
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
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: TColors.tertiaryColor),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        /*Image.asset(
                                          "assets/images/dashboard_images/math_tutor.png", // Placeholder image
                                          width: 100,
                                        ),*/
                                        tutor.tutorImage != null
                                            ? Image.network(
                                                tutor.tutorImage!,
                                                // Placeholder image
                                                width: 100,
                                              )
                                            : tutor.tutorName == "Mathematics"
                                                ?Image.network(
                                          "https://rishoguru.sgp1.digitaloceanspaces.com/dsr/math_tutor",
                                          // Placeholder image
                                          width: 100,
                                        ):tutor.tutorName == "English Grammar"
                                            ?Image.network(
                                          "https://rishoguru.sgp1.digitaloceanspaces.com/dsr/eng_grammar_tutor",
                                          // Placeholder image
                                          width: 100,
                                        ):CircleAvatar(
                                          radius:40,
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
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: TSizes.spaceBtwItems),
                        ],
                      ),
                    ),

                    /*Consumer<TutorProvider>(
                      builder: (context, tutorProvider, child) {
                        // Check if the data is loading
                        if (tutorProvider.isLoading) {
                          return Center(child: CircularProgressIndicator()); // Show loading indicator
                        }

                        // Check for errors
                        if (tutorProvider.errorMessage != null) {
                          return Center(child: Text("Error: ${tutorProvider.errorMessage}"));
                        }

                        // If no tutors available, show a message
                        if (tutorProvider.tutors.isEmpty) {
                          return Center(child: Text("No tutors available"));
                        }

                        // Tutors data is available
                        final tutors = tutorProvider.tutors;

                        return SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: tutors.length,
                            // physics: NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final tutor = tutors[index];
                              return ListTile(
                                leading: tutor.tutorImage != null
                                    ? CircleAvatar(
                                  backgroundImage: NetworkImage(tutor.tutorImage!),
                                )
                                    : CircleAvatar(child: Icon(Icons.person)),
                                title: Text(tutor.tutorName),
                                subtitle: Text(tutor.tutorSubjects),
                              );
                            },
                          ),
                        );
                      },
                    ),*/

                    // SizedBox(height: TSizes.sm),
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
                                  "",
                                ),
                              ),
                              Expanded(
                                child: _buildToolLargeCard(
                                  'মনোবিজ্ঞানীর সাহায্য',
                                  'হতাশা কাটিয়ে উঠুন, নতুন করে শুরু করুন',
                                  "assets/images/dashboard_images/mental_health.png",
                                  TColors.primaryColor,
                                  "",
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
  ) {
    return GestureDetector(
      onTap: () {
        print('$title pressed, $staticToolsCode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToolsContentScreen(
              staticToolsCode: staticToolsCode,
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

  Widget _buildToolLargeCard(
    String title,
    String subtitle,
    String image,
    Color color,
    String staticToolsCode,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ToolsContentScreen(staticToolsCode: staticToolsCode)),
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
