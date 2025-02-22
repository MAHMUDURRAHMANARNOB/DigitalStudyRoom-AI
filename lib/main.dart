import 'package:digital_study_room/app.dart';
import 'package:digital_study_room/features/Tutor/providers/TutorsProvider.dart';
import 'package:digital_study_room/features/authentication/providers/AuthProvider.dart';
import 'package:digital_study_room/features/profile/Providers/SubscriptionStatusProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/ToolsContent/provider/ToolsResponseProvider.dart';
import 'features/ToolsContent/provider/studyToolsProvider.dart';
import 'features/ToolsContent/provider/toolsDataByCodeProvider.dart';
import 'features/ToolsContent/provider/toolsReplyProvider.dart';
import 'features/Tutor/providers/TutorResponseProvider.dart';

/*void main() {
  runApp(const MyApp());
}*/
// ---- Entry Point of Flutter App ----
void main() {
  // TODO: Add Widget Binding / Multi-Providers
  // TODO: init Local Storage
  // TODO: Await Native Splash
  // TODO: Initialize FireBase
  // TODO: Initialize Authentication

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => StudyToolsProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionStatusProvider()),
        ChangeNotifierProvider(
          create: (context) => ToolsDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToolsResponseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToolsReplyProvider(),
        ),ChangeNotifierProvider(
          create: (context) => TutorResponseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TutorProvider(),
        ),
      ],
      child: DigitalStudyRoom(),
    ),
  );
}
