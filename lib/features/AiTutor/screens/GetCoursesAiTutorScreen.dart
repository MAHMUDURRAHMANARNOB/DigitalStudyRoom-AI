/*
// features/AiTutor/screens/GetCoursesAiTutorScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../PdfReader/screens/PdfHomeScreen.dart';
import '../datamodels/getCoursesDataModel.dart';
import '../providers/getCoursesAiTutorProvider.dart';
import 'GetChaptersAiTutorScreen.dart';

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
        centerTitle: true,
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
                  */
/*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pdfUrl: course.coursePDFLink,
                        subjectName: course.subjectName,
                      ),
                    ),
                  );*//*

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetChaptersAiTutorListScreen(
                        classId: widget.classId,
                        subjectId: course.subjectId.toString(),
                        courseName: course.subjectName, pdfUrl: course.coursePDFLink,
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
*/
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../datamodels/getCoursesDataModel.dart';
import '../providers/getCoursesAiTutorProvider.dart';
import 'GetChaptersAiTutorScreen.dart';

class GetCourseAiTutorListScreen extends StatefulWidget {
  final String userId;
  final String classId;

  const GetCourseAiTutorListScreen({
    Key? key,
    required this.userId,
    required this.classId,
  }) : super(key: key);

  @override
  State<GetCourseAiTutorListScreen> createState() => _GetCourseAiTutorListScreenState();
}

class _GetCourseAiTutorListScreenState extends State<GetCourseAiTutorListScreen> {
  late Future<List<GetCoursesDataModel>> _fetchCoursesFuture;

  @override
  void initState() {
    super.initState();
    _fetchCoursesFuture = Provider.of<GetCoursesAiTutorProvider>(context, listen: false)
        .fetchAiTutorCourses(widget.userId, widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor Courses', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50], // Light background
        child: FutureBuilder<List<GetCoursesDataModel>>(
          future: _fetchCoursesFuture,
          builder: (context, snapshot) {
            // Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildLoadingShimmer(),
                    const SizedBox(height: 30),
                    Text(
                      'Loading Your Courses...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(TColors.primaryColor),
                    ),
                  ],
                ),
              );
            }

            // Error State
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: TColors.error),
                    const SizedBox(height: 20),
                    Text(
                      'Failed to load courses',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   '${snapshot.error}',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: Colors.grey[600]),
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.error,
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: TColors.error),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          _fetchCoursesFuture = Provider.of<GetCoursesAiTutorProvider>(context, listen: false)
                              .fetchAiTutorCourses(widget.userId, widget.classId);
                        });
                      },
                      child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            // Empty State
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'No courses available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Check back later for new courses',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            // Success State
            final courses = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                itemCount: courses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(course, context);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseCard(GetCoursesDataModel course, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GetChaptersAiTutorListScreen(
                classId: widget.classId,
                subjectId: course.subjectId.toString(),
                courseName: course.subjectName,
                pdfUrl: course.coursePDFLink,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Course Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TColors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(course.subjectName),
                  color: TColors.deepPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.subjectName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to view chapters',
                      style: TextStyle(
                        fontSize: 13,
                        color: TColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.open_in_new, size: 20),
                    color: Colors.grey[600],
                    onPressed: () async {
                      final url = Uri.parse(course.coursePDFLink);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot open PDF in browser')),
                        );
                      }
                    },
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) =>
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Container(
                height: 80,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  IconData _getSubjectIcon(String subjectName) {
    final lowerName = subjectName.toLowerCase();
    if (lowerName.contains('math')) return Icons.calculate;
    if (lowerName.contains('science')) return Icons.science;
    if (lowerName.contains('english')) return Icons.language;
    if (lowerName.contains('history')) return Icons.history_edu;
    if (lowerName.contains('bangla')) return Icons.menu_book;
    return Icons.school;
  }
}