// Screen View with FutureBuilder
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../PdfReader/screens/PdfHomeScreen.dart';
import '../datamodels/getChaptersDataModel.dart';
import '../providers/getChaptersAiTutorProvider.dart';

/*class GetChaptersAiTutorListScreen extends StatefulWidget {
  final String courseName;
  final String classId;
  final String subjectId;
  final String pdfUrl;

  const GetChaptersAiTutorListScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.courseName,
    required this.pdfUrl,
  });

  @override
  State<GetChaptersAiTutorListScreen> createState() =>
      _GetChaptersAiTutorListScreenState();
}

class _GetChaptersAiTutorListScreenState
    extends State<GetChaptersAiTutorListScreen> {
  @override
  Widget build(BuildContext context) {
    // Access the ChapterProvider
    final chapterProvider =
        Provider.of<GetChaptersAiTutorProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: chapterProvider.fetchChaptersAiTutor(
            widget.classId, widget.subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Access chapters from provider after fetch is complete
          final chapters = chapterProvider.chapters;

          if (chapters.isEmpty) {
            return const Center(child: Text('No chapters found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: TColors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Iconsax.book,color: TColors.deepPurple,),
                  title: Text(chapter.chapterName,style: TextStyle(color: TColors.deepPurple,fontSize: 18),),
                  subtitle: Text(
                      'Pages: ${chapter.chapStartPage} - ${chapter.chapEndPage}'),
                  onTap: () {
                    // Add navigation or action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          pdfUrl: widget.pdfUrl,
                          subjectName: chapter.chapterName,
                          startPage: chapter.chapStartPage,
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
    );
  }
}*/
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class GetChaptersAiTutorListScreen extends StatefulWidget {
  final String courseName;
  final String classId;
  final String subjectId;
  final String pdfUrl;
  final String userId;

  const GetChaptersAiTutorListScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.courseName,
    required this.pdfUrl, required this.userId,
  });

  @override
  State<GetChaptersAiTutorListScreen> createState() =>
      _GetChaptersAiTutorListScreenState();
}

class _GetChaptersAiTutorListScreenState
    extends State<GetChaptersAiTutorListScreen> {
  @override
  Widget build(BuildContext context) {
    final chapterProvider =
    Provider.of<GetChaptersAiTutorProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: TColors.deepPurple),
      ),
      body: Container(
        color: Colors.grey[50],
        child: FutureBuilder<void>(
          future: chapterProvider.fetchChaptersAiTutor(
              widget.classId, widget.subjectId),
          builder: (context, snapshot) {
            // Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            // Error State
            if (snapshot.hasError) {
              return _buildErrorState(snapshot, chapterProvider);
            }

            // Access chapters from provider
            final chapters = chapterProvider.chapters;

            // Empty State
            if (chapters.isEmpty) {
              return _buildEmptyState();
            }

            // Success State
            return _buildChapterList(chapters);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(TColors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Chapters...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: List.generate(
                3,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                height: 14,
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
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      AsyncSnapshot<void> snapshot, GetChaptersAiTutorProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Failed to load chapters',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              '${snapshot.error}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                provider.fetchChaptersAiTutor(widget.classId, widget.subjectId);
              });
            },
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.nearby_error_rounded,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Chapters Available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Check back later for updated content',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back to Courses',
              style: TextStyle(
                color: TColors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList(List<AiTutorChapter> chapters) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: chapters.length,
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Card(
            color: TColors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                print("chapter id - ${chapter.id}, chapter Page - ${chapter.chapStartPage}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      pdfUrl: widget.pdfUrl,
                      subjectName: chapter.chapterName,
                      startPage: chapter.chapStartPage, userId: widget.userId, courseId: widget.subjectId.toString(), chapterId: chapter.id.toString(),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: TColors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.book_1,
                        color: TColors.deepPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.chapterName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pages ${chapter.chapStartPage}-${chapter.chapEndPage}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
