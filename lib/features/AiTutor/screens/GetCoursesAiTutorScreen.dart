// features/AiTutor/screens/GetCoursesAiTutorScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../PdfReader/screens/PdfHomeScreen.dart';
import '../datamodels/getCoursesDataModel.dart';
import '../providers/getCoursesAiTutorProvider.dart';

class GetCourseAiTutorListScreen extends StatefulWidget {
  final String userId;
  final String classId;

  const GetCourseAiTutorListScreen({
    Key? key,
    required this.userId,
    required this.classId,
  }) : super(key: key);

  @override
  State<GetCourseAiTutorListScreen> createState() =>
      _GetCourseAiTutorListScreenState();
}

class _GetCourseAiTutorListScreenState
    extends State<GetCourseAiTutorListScreen> {
  late Future<List<GetCoursesDataModel>> _fetchCoursesFuture;

  @override
  void initState() {
    super.initState();
// Initialize the future in initState
    _fetchCoursesFuture =
        Provider.of<GetCoursesAiTutorProvider>(context, listen: false)
            .fetchAiTutorCourses(widget.userId, widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: FutureBuilder<List<GetCoursesDataModel>>(
        future: _fetchCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fetchCoursesFuture =
                            Provider.of<GetCoursesAiTutorProvider>(context,
                                    listen: false)
                                .fetchAiTutorCourses(
                                    widget.userId, widget.classId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course.subjectName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pdfUrl: course.coursePDFLink,
                        subjectName: course.subjectName,
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () async {
                    final url = Uri.parse(course.coursePDFLink);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Cannot open PDF in browser')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
