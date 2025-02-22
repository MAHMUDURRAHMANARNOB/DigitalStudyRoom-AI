import 'package:digital_study_room/features/Tutor/screens/TutorStudyScreen.dart';
import 'package:flutter/material.dart';

class ChaptersScreen extends StatefulWidget {
  final String courseTutorName;
  final String subject;

  ChaptersScreen(
      {super.key, required this.courseTutorName, required this.subject});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final List<String> mathTopics = [
    'Algebra',
    'Geometry',
    'Trigonometry',
    'Calculus',
    'Probability & Statistics',
    'Linear Algebra',
    'Number Theory',
    'Discrete Mathematics',
    'Differential Equations',
    'Complex Numbers'
  ];

  final List<String> englishGrammarTopics = [
    'Adjectives',
    'Adverbs',
    'Pronouns',
    'Prepositions',
    'Tenses',
    'Reported Speech',
    'Auxiliary verbs',
    'Parts of speech',
    'Gerunds & Infinitives',
    'Articles',
    'Complex Sentences',
  ];

  final List<String> scienceTopics = [
    'Chemistry',
    'Geometry',
    'Trigonometry',
    'Calculus',
    'Probability & Statistics',
    'Linear Algebra',
    'Number Theory',
    'Discrete Mathematics',
    'Differential Equations',
    'Complex Numbers'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTutorName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: widget.subject == "Mathematics"
            ? MathTopicList(mathTopics: mathTopics, widget: widget)
            : widget.subject == "Science"
                ? ScienceTopicList(scienceTopics: scienceTopics, widget: widget)
                : EnglishGrammarTopicList(
                    englishGrammarTopics: englishGrammarTopics, widget: widget),
      ),
    );
  }
}

class MathTopicList extends StatelessWidget {
  const MathTopicList({
    super.key,
    required this.mathTopics,
    required this.widget,
  });

  final List<String> mathTopics;
  final ChaptersScreen widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mathTopics.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              mathTopics[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.calculate, color: Colors.green),
            onTap: () {
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${mathTopics[index]} selected!')),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorStudyScreen(
                    topic: '${mathTopics[index]}',
                    subject: widget.subject,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class EnglishGrammarTopicList extends StatelessWidget {
  const EnglishGrammarTopicList({
    super.key,
    required this.englishGrammarTopics,
    required this.widget,
  });

  final List<String> englishGrammarTopics;
  final ChaptersScreen widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: englishGrammarTopics.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              englishGrammarTopics[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.calculate, color: Colors.green),
            onTap: () {
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${mathTopics[index]} selected!')),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorStudyScreen(
                    topic: englishGrammarTopics[index],
                    subject: widget.subject,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ScienceTopicList extends StatelessWidget {
  const ScienceTopicList({
    super.key,
    required this.scienceTopics,
    required this.widget,
  });

  final List<String> scienceTopics;
  final ChaptersScreen widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: scienceTopics.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              scienceTopics[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.calculate, color: Colors.green),
            onTap: () {
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${mathTopics[index]} selected!')),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorStudyScreen(
                    topic: scienceTopics[index],
                    subject: widget.subject,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
