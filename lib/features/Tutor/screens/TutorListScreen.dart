import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../authentication/providers/AuthProvider.dart';
import '../../authentication/providers/SelectClassProvider.dart';
import '../providers/TutorsProvider.dart';
import 'ChaptersScreen.dart';

class TutorsListScreen extends StatelessWidget {
  const TutorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = THelperFunction.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final classId = authProvider.user!.classId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Your Tutor",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Choose your preferred tutor to start learning",
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? Colors.white70 : Colors.black54,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<void>(
                future: Provider.of<TutorProvider>(context, listen: false).fetchTutors(classId!),
                builder: (context, snapshot) {
                  // Check if data is loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: TColors.primaryColor,
                      ),
                    );
                  }

                  // Check for errors
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final tutors = Provider.of<TutorProvider>(context).tutors;

                  // If no tutors available
                  if (tutors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 50,
                            color: TColors.primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No tutors available",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Return scrollable containers for tutors
                  return ListView.builder(
                    itemCount: tutors.length,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      final tutor = tutors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChaptersScreen(
                                courseTutorName: tutor.tutorName,
                                tutorId: tutor.id,
                                subject: tutor.tutorSubjects,
                                subjectId: tutor.subjectID!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: dark ? Colors.grey[900] : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: TColors.tertiaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: tutor.tutorImage != null
                                    ? Image.network(
                                  tutor.tutorImage!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  width: 80,
                                  height: 80,
                                  color: TColors.tertiaryColor.withOpacity(0.2),
                                  child: Icon(
                                    CupertinoIcons.person_fill,
                                    color: TColors.primaryColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tutor.tutorName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      tutor.tutorSubjects,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: dark ? Colors.white70 : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: dark ? Colors.white54 : Colors.black54,
                              ),
                            ],
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