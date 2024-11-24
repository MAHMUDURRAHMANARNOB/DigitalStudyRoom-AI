import 'package:digital_study_room/features/CourseContent/screens/LessonListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/curved_edges/courses_container_clipper.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';

class CourseContainer extends StatelessWidget {
  const CourseContainer({
    super.key,
    required this.courseCategory,
    required this.courseTitle,
    required this.totalEnrolled,
    this.progress,
    required this.isEnrolled,
    this.enrolledBackgroundColor,
    this.unEnrolledCoursesColor,
  });

  final Color? enrolledBackgroundColor, unEnrolledCoursesColor;
  final String courseCategory, courseTitle, totalEnrolled;
  final bool isEnrolled;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunction.isDarkMode(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            isEnrolled
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonListScreen(
                        courseTitle: courseTitle,
                      ),
                    ),
                  )
                : showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.white,
                      // title: const Text("Confirming your enrollment to",style: TextStyle(fontSize: 30),),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Image.asset(
                              "assets/images/startlearning.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text(
                            courseTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(),
                          ),
                          const Text(
                            "চাকরি কিংবা নিজের মতো ক্যারিয়ার গড়ার জন্য সহজেই শেখা যেতে পারে এমন একটি প্রোগ্রামিং ল্যাঙ্গুয়েজ হচ্ছে Python। আমাদের এই কোর্সে Python প্রোগ্রামিং ভাষার বেসিক টু অ্যাডভান্স সব থিওরি শেখানো হয়েছে হাতেকলমে, বিভিন্ন প্র্যাকটিকাল প্রজেক্ট সম্পন্ন করার মাধ্যমে। পাশাপাশি দেওয়া হয়েছে এই স্কিলের মাধ্যমে ক্যারিয়ার গড়ার সকল industry সম্পর্কে ধারণা! ",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: TColors.darkGrey),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primaryColor),
                          onPressed: () {},
                          child: Container(
                            width: double.infinity,
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
          child: ClipPath(
            // clipper: CoursesContainerClipper(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
              width: 200,
              // height: 200,
              decoration: BoxDecoration(
                color: isEnrolled
                    ? darkMode
                        ? enrolledBackgroundColor
                        : enrolledBackgroundColor!.withOpacity(0.3)
                    : darkMode
                        ? unEnrolledCoursesColor
                        : unEnrolledCoursesColor!.withOpacity(0.3),
                borderRadius: BorderRadius.all(
                    Radius.circular(TSizes.borderRadiusXXL / 2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseTitle,
                      style: isEnrolled
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.headlineMedium,
                      maxLines: 3, // Ensuring the title fits within two lines
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: TSizes.sm),
                    isEnrolled
                        ? SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Progress: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${progress! * 100}%",
                                  style: TextStyle(
                                    color: TColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: !isEnrolled,
                                child: TextButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: Text(
                                    courseCategory,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              const SizedBox(height: TSizes.sm),
                              Row(
                                children: [
                                  Text(
                                    "Total Enrolled: ",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    totalEnrolled,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Visibility(
                      visible: isEnrolled,
                      child: SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              TColors.primaryColor),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isEnrolled,
                      child: const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        /*Positioned(
          bottom: 6,
          right: 10,
          child: SizedBox(
            child: IconButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled
                    ? darkMode
                        ? enrolledBackgroundColor!.withOpacity(0.5)
                        : enrolledBackgroundColor
                    : darkMode
                        ? unEnrolledCoursesColor!.withOpacity(0.5)
                        : unEnrolledCoursesColor,
                shape: CircleBorder(),
              ),
              onPressed: () {
                // selectedCourseTitle==courseTitle;
                isEnrolled
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonListScreen(
                            courseTitle: courseTitle,
                          ),
                        ),
                      )
                    : showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          // title: const Text("Confirming your enrollment to",style: TextStyle(fontSize: 30),),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/startlearning.png",
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                "Start Class",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .apply(),
                              ),
                              Chip(
                                backgroundColor: TColors.primaryColor.withOpacity(0.1),
                                side: BorderSide(color: TColors.primaryColor),
                                label: Text(
                                  // textAlign: TextAlign.left,
                                  courseTitle,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primaryColor),
                                onPressed: () {},
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(TSizes.defaultSpace / 1.4),
            ),
          ),
        ),*/
      ],
    );
  }
}
