import 'package:digital_study_room/features/Tutor/screens/TutorStudyScreen.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../utils/helpers/helper_function.dart';
import '../../authentication/providers/AuthProvider.dart';
import '../providers/TutorChapterListProvider.dart';

class ChaptersScreen extends StatefulWidget {
  final String courseTutorName;
  final String subject;
  final String subjectId;
  final int tutorId;

  ChaptersScreen(
      {super.key,
      required this.courseTutorName,
      required this.subject,
      required this.subjectId,
      required this.tutorId});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    classid = authProvider.user?.classId;

    Future.microtask(() =>
        Provider.of<TutorsChapterProvider>(context, listen: false)
            .fetchTutorsChapters(classid.toString(), widget.subjectId));
  }

  late final classid;
  late final authProvider;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTutorName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 6),
              child: Text(
                "Chapters of ${widget.courseTutorName}, class - $classid",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Consumer<TutorsChapterProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: TColors.primaryColor,
                    ));
                  }
                  if (provider.chapters == null || provider.chapters!.isEmpty) {
                    return Center(child: Text("No chapters available"));
                  }
                  return ListView.builder(
                    itemCount: provider.chapters!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: TColors.darkGrey),
                        ),
                        elevation: 1,
                        color: TColors.white,
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            title: Text(
                              provider.chapters![index].chapterName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: TColors.tertiaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: /*Icon(
                                CupertinoIcons.book_solid,
                                color: TColors.tertiaryColor,
                                size: 30,
                              ),*/
                              Image.asset("assets/images/items/interactive_student_lesson.png"),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TutorStudyScreen(
                                    topic: provider.chapters![index].chapterName,
                                    tutorId: widget.tutorId,
                                    subject: widget.subject,
                                    chapterId: provider.chapters![index].id,
                                  ),
                                ),
                              );
                            },
              
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
