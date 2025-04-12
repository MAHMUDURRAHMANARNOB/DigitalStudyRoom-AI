import 'package:digital_study_room/features/Tutor/screens/TutorStudyScreen.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/providers/AuthProvider.dart';
import '../providers/TutorChapterListProvider.dart';

class ChaptersScreen extends StatefulWidget {
  final String courseTutorName;
  final String subject;
  final String subjectId;
  final int tutorId;

  ChaptersScreen(
      {super.key, required this.courseTutorName, required this.subject, required this.subjectId, required this.tutorId});

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
        child: Consumer<TutorsChapterProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: TColors.primaryColor,));
            }
            if (provider.chapters == null || provider.chapters!.isEmpty) {
              return Center(child: Text("No chapters available"));
            }
            return ListView.builder(
              itemCount: provider.chapters!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  surfaceTintColor: TColors.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      provider.chapters![index].chapterName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.calculate, color: TColors.primaryColor,size: 30,),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorStudyScreen(
                            topic: provider.chapters![index].chapterName,
                            tutorId: widget.tutorId,
                            subject: widget.subject, chapterId: provider.chapters![index].id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
