import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../datamodels/mcqDataModels.dart';
import '../providers/mcqExamProvider.dart';

class McqView extends StatelessWidget {
  final String userId;
  final String courseId;
  final String chapterId;
  final String pageId;
  final String isFullExam;
  final File? pageImage; // From PdfViewerScreen

  McqView({
    required this.userId,
    required this.courseId,
    required this.chapterId,
    required this.pageId,
    required this.isFullExam,
    this.pageImage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => McqProvider(),
      child: McqScreen(
        userId: userId,
        courseId: courseId,
        chapterId: chapterId,
        pageId: pageId,
        isFullExam: isFullExam,
        pageImage: pageImage,
      ),
    );
  }
}

class McqScreen extends StatelessWidget {
  final String userId;
  final String courseId;
  final String chapterId;
  final String pageId;
  final String isFullExam;
  final File? pageImage;

  McqScreen({
    required this.userId,
    required this.courseId,
    required this.chapterId,
    required this.pageId,
    required this.isFullExam,
    this.pageImage,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<McqProvider>(context, listen: false);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchQuestion(McqRequest(
        userId: userId,
        courseId: courseId,
        chapterId: chapterId,
        pageId: pageId,
        isFullExam: isFullExam,
        pageImage: pageImage,
      ));
    });

    return Scaffold(
      appBar: AppBar(title: Text('MCQ Exam')),
      body: Consumer<McqProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: TColors.primaryColor,
            ));
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Card(
                  color: TColors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Error!",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: TColors.error),
                        ),
                        SizedBox(height: 20),
                        Text(
                          provider.errorMessage!,
                          style:
                              TextStyle(fontSize: 16, color: TColors.darkGrey),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.error,
                            side: BorderSide(color: TColors.white),
                          ),
                          onPressed: () {
                            provider.fetchQuestion(McqRequest(
                              userId: userId,
                              courseId: courseId,
                              chapterId: chapterId,
                              pageId: pageId,
                              isFullExam: isFullExam,
                              pageImage: pageImage,
                            ));
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Retry',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // SizedBox(height: TSizes.sm),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.white,
                            side: BorderSide(color: TColors.black, width: 1),
                          ),
                          onPressed: () {
                            provider.reset();
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Back to PDF Viewer',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (provider.currentResponse == null ||
              (provider.currentResponse?.errorCode == 301 &&
                  provider.currentResponse?.question == null)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.currentResponse?.message ??
                        'No question available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    child: Text('Back to PDF Viewer'),
                  ),
                ],
              ),
            );
          }

          if (provider.currentResponse?.isExamCompleted == 'Y') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Exam Completed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (provider.currentResponse?.totalAttended != null)
                    Text(
                        'Total Attempted: ${provider.currentResponse!.totalAttended}'),
                  if (provider.currentResponse?.totalCorrect != null)
                    Text('Correct: ${provider.currentResponse!.totalCorrect}'),
                  if (provider.currentResponse?.totalWrong != null)
                    Text('Wrong: ${provider.currentResponse!.totalWrong}'),
                  if (provider.currentResponse?.totalSkip != null)
                    Text('Skipped: ${provider.currentResponse!.totalSkip}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.reset,
                    child: Text('Restart Exam'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.currentResponse!.question ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (pageImage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(
                      pageImage!,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ...?provider.currentResponse!.answers?.map((answer) {
                  return RadioListTile(
                    title: Text(answer.ansText),
                    value: answer,
                    groupValue: provider.selectedAnswer,
                    onChanged: provider.showExplanation
                        ? null
                        : (value) {
                            provider.selectAnswer(
                              answer,
                              McqRequest(
                                userId: userId,
                                courseId: courseId,
                                chapterId: chapterId,
                                pageId: pageId,
                                isFullExam: isFullExam,
                                pageImage: pageImage,
                              ),
                            );
                          },
                  );
                }).toList(),
                SizedBox(height: TSizes.spaceBtwItems),
                if (provider.showExplanation &&
                    provider.selectedAnswer != null) ...[
                  SizedBox(height: 20),
                  Text(
                    provider.selectedAnswer!.isCorrect == 'Y'
                        ? 'Correct!'
                        : 'Incorrect: ${provider.selectedAnswer!.explanation}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: provider.selectedAnswer!.isCorrect == 'Y'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  if (provider.selectedAnswer!.isCorrect == 'N')
                    ElevatedButton(
                      onPressed: () {
                        provider.showExplanation = false;
                        provider.selectedAnswer = null;
                        provider.notifyListeners();
                      },
                      child: Container(
                          width: double.infinity,
                          child: Text(
                            'Try Again',
                            textAlign: TextAlign.center,
                          )),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
