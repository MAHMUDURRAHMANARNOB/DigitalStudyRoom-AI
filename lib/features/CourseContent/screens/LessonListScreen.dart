import 'package:digital_study_room/features/CourseContent/screens/LessonBoardScreen.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_shapes/containers/circular_container.dart';

class LessonListScreen extends StatefulWidget {
  final String courseTitle;

  const LessonListScreen({super.key, required this.courseTitle});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.courseTitle,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "12th Grade",
                    style: TextStyle(
                      color: TColors.darkGrey,
                    ),
                  ),
                  SizedBox(
                    height: TSizes.md,
                  ),
                  Container(
                    child: const Text("Lessons: "),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10, // 10 items in the list
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonBoardScreen(
                                lessonTitle: "Lesson ${index + 1}",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 1),
                                // blurStyle: BlurStyle.inner
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: TColors.primaryColor.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Icon(
                                  Icons.chrome_reader_mode_outlined,
                                  // Replace with your desired icon
                                  color: TColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                'Lesson ${index + 1}', // Dynamically set the text
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
